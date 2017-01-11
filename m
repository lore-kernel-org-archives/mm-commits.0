From: akpm@linux-foundation.org
Subject: [patch 07/27] bpf: do not use KMALLOC_SHIFT_MAX
Date: Tue, 10 Jan 2017 16:57:30 -0800
Message-ID: <587582fa.lAxi4uoi3Z5SopvZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759993AbdAKA5f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:57:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, andreyknvl@google.com, ast@kernel.org, cl@linux.com

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
