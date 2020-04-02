From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 055/155] mm/swapfile: fix data races in
 try_to_unuse()
Date: Wed, 01 Apr 2020 21:06:13 -0700
Message-ID: <20200402040613.A8knyzgJ0%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEGO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:06:14 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, elver@google.com, hughd@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Qian Cai <cai@lca.pw>
Subject: mm/swapfile: fix data races in try_to_unuse()

si->inuse_pages could be accessed concurrently as noticed by KCSAN,

 write to 0xffff98b00ebd04dc of 4 bytes by task 82262 on cpu 92:
  swap_range_free+0xbe/0x230
  swap_range_free at mm/swapfile.c:719
  swapcache_free_entries+0x1be/0x250
  free_swap_slot+0x1c8/0x220
  __swap_entry_free.constprop.19+0xa3/0xb0
  free_swap_and_cache+0x53/0xa0
  unmap_page_range+0x7e0/0x1ce0
  unmap_single_vma+0xcd/0x170
  unmap_vmas+0x18b/0x220
  exit_mmap+0xee/0x220
  mmput+0xe7/0x240
  do_exit+0x598/0xfd0
  do_group_exit+0x8b/0x180
  get_signal+0x293/0x13d0
  do_signal+0x37/0x5d0
  prepare_exit_to_usermode+0x1b7/0x2c0
  ret_from_intr+0x32/0x42

 read to 0xffff98b00ebd04dc of 4 bytes by task 82499 on cpu 46:
  try_to_unuse+0x86b/0xc80
  try_to_unuse at mm/swapfile.c:2185
  __x64_sys_swapoff+0x372/0xd40
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The plain reads in try_to_unuse() are outside si->lock critical section
which result in data races that could be dangerous to be used in a loop. 
Fix them by adding READ_ONCE().

Link: http://lkml.kernel.org/r/1582578903-29294-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-fix-data-races-in-try_to_unuse
+++ a/mm/swapfile.c
@@ -2132,7 +2132,7 @@ int try_to_unuse(unsigned int type, bool
 	swp_entry_t entry;
 	unsigned int i;
 
-	if (!si->inuse_pages)
+	if (!READ_ONCE(si->inuse_pages))
 		return 0;
 
 	if (!frontswap)
@@ -2148,7 +2148,7 @@ retry:
 
 	spin_lock(&mmlist_lock);
 	p = &init_mm.mmlist;
-	while (si->inuse_pages &&
+	while (READ_ONCE(si->inuse_pages) &&
 	       !signal_pending(current) &&
 	       (p = p->next) != &init_mm.mmlist) {
 
@@ -2177,7 +2177,7 @@ retry:
 	mmput(prev_mm);
 
 	i = 0;
-	while (si->inuse_pages &&
+	while (READ_ONCE(si->inuse_pages) &&
 	       !signal_pending(current) &&
 	       (i = find_next_to_unuse(si, i, frontswap)) != 0) {
 
@@ -2219,7 +2219,7 @@ retry:
 	 * been preempted after get_swap_page(), temporarily hiding that swap.
 	 * It's easy and robust (though cpu-intensive) just to keep retrying.
 	 */
-	if (si->inuse_pages) {
+	if (READ_ONCE(si->inuse_pages)) {
 		if (!signal_pending(current))
 			goto retry;
 		retval = -EINTR;
_
