From: akpm@linux-foundation.org
Subject: + bpf-do-not-use-kmalloc_shift_max.patch added to -mm tree
Date: Tue, 20 Dec 2016 14:34:46 -0800
Message-ID: <5859b206.LcObdKxOnBJy0jD0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753370AbcLTWdo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Dec 2016 17:33:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andreyknvl@google.com, ast@kernel.org, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bpf: do not use KMALLOC_SHIFT_MAX
has been added to the -mm tree.  Its filename is
     bpf-do-not-use-kmalloc_shift_max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bpf-do-not-use-kmalloc_shift_max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bpf-do-not-use-kmalloc_shift_max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: bpf: do not use KMALLOC_SHIFT_MAX

01b3f52157ff ("bpf: fix allocation warnings in bpf maps and integer
overflow") has added checks for the maximum allocateable size.  It
(ab)used KMALLOC_SHIFT_MAX for that purpose.  While this is not incorrect
it is not very clean because we already have KMALLOC_MAX_SIZE for this
very reason so let's change both checks to use KMALLOC_MAX_SIZE instead.

The original motivation for using KMALLOC_SHIFT_MAX was to work around an
incorrect KMALLOC_MAX_SIZE which could lead to allocation warnings but it
is no longer needed since "slab: make sure that KMALLOC_MAX_SIZE will fit
into MAX_ORDER".

Link: http://lkml.kernel.org/r/20161220130659.16461-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/bpf/arraymap.c |    2 +-
 kernel/bpf/hashtab.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/bpf/arraymap.c~bpf-do-not-use-kmalloc_shift_max kernel/bpf/arraymap.c
--- a/kernel/bpf/arraymap.c~bpf-do-not-use-kmalloc_shift_max
+++ a/kernel/bpf/arraymap.c
@@ -56,7 +56,7 @@ static struct bpf_map *array_map_alloc(u
 	    attr->value_size == 0 || attr->map_flags)
 		return ERR_PTR(-EINVAL);
 
-	if (attr->value_size >= 1 << (KMALLOC_SHIFT_MAX - 1))
+	if (attr->value_size > KMALLOC_MAX_SIZE)
 		/* if value_size is bigger, the user space won't be able to
 		 * access the elements.
 		 */
diff -puN kernel/bpf/hashtab.c~bpf-do-not-use-kmalloc_shift_max kernel/bpf/hashtab.c
--- a/kernel/bpf/hashtab.c~bpf-do-not-use-kmalloc_shift_max
+++ a/kernel/bpf/hashtab.c
@@ -274,7 +274,7 @@ static struct bpf_map *htab_map_alloc(un
 		 */
 		goto free_htab;
 
-	if (htab->map.value_size >= (1 << (KMALLOC_SHIFT_MAX - 1)) -
+	if (htab->map.value_size >= KMALLOC_MAX_SIZE -
 	    MAX_BPF_STACK - sizeof(struct htab_elem))
 		/* if value_size is bigger, the user space won't be able to
 		 * access the elements via bpf syscall. This check also makes
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-slab-make-sure-that-kmalloc_max_size-will-fit-into-max_order.patch
bpf-do-not-use-kmalloc_shift_max.patch
mm-throttle-show_mem-from-warn_alloc.patch

