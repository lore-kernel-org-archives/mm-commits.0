From: akpm@linux-foundation.org
Subject: + revert-slab-remove-bad_alien_magic.patch added to -mm tree
Date: Fri, 08 Aug 2014 12:53:56 -0700
Message-ID: <53e52ad4.pLcFEDFXv8hIqsEG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f201.google.com ([209.85.213.201]:64349 "EHLO
	mail-ig0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaHHTx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 15:53:57 -0400
Received: by mail-ig0-f201.google.com with SMTP id h3so237553igd.0
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 12:53:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, geert@linux-m68k.org, penberg@kernel.org, rientjes@google.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "slab: remove BAD_ALIEN_MAGIC"
has been added to the -mm tree.  Its filename is
     revert-slab-remove-bad_alien_magic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-slab-remove-bad_alien_magic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-slab-remove-bad_alien_magic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Revert "slab: remove BAD_ALIEN_MAGIC"

This reverts commit a640616822b2 ("slab: remove BAD_ALIEN_MAGIC").

commit a640616822b2 ("slab: remove BAD_ALIEN_MAGIC") assumes that the
system with !CONFIG_NUMA has only one memory node.  But, it turns out to
be false by the report from Geert.  His system, m68k, has many memory
nodes and is configured in !CONFIG_NUMA.  So it couldn't boot with above
change.

Here goes his failure report.

  With latest mainline, I'm getting a crash during bootup on m68k/ARAnyM:

  enable_cpucache failed for radix_tree_node, error 12.
  kernel BUG at /scratch/geert/linux/linux-m68k/mm/slab.c:1522!
  *** TRAP #7 ***   FORMAT=0
  Current process id is 0
  BAD KERNEL TRAP: 00000000
  Modules linked in:
  PC: [<0039c92c>] kmem_cache_init_late+0x70/0x8c
  SR: 2200  SP: 00345f90  a2: 0034c2e8
  d0: 0000003d    d1: 00000000    d2: 00000000    d3: 003ac942
  d4: 00000000    d5: 00000000    a0: 0034f686    a1: 0034f682
  Process swapper (pid: 0, task=0034c2e8)
  Frame format=0
  Stack from 00345fc4:
          002f69ef 002ff7e5 000005f2 000360fa 0017d806 003921d4 00000000
          00000000 00000000 00000000 00000000 00000000 003ac942 00000000
          003912d6
  Call Trace: [<000360fa>] parse_args+0x0/0x2ca
   [<0017d806>] strlen+0x0/0x1a
   [<003921d4>] start_kernel+0x23c/0x428
   [<003912d6>] _sinittext+0x2d6/0x95e

  Code: f7e5 4879 002f 69ef 61ff ffca 462a 4e47 <4879> 0035 4b1c 61ff
  fff0 0cc4 7005 23c0 0037 fd20 588f 265f 285f 4e75 48e7 301c
  Disabling lock debugging due to kernel taint
  Kernel panic - not syncing: Attempted to kill the idle task!

Although there is a alternative way to fix this issue such as disabling
use of alien cache on !CONFIG_NUMA, but, reverting issued commit is better
to me in this time.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/slab.c~revert-slab-remove-bad_alien_magic mm/slab.c
--- a/mm/slab.c~revert-slab-remove-bad_alien_magic
+++ a/mm/slab.c
@@ -470,6 +470,8 @@ static struct kmem_cache kmem_cache_boot
 	.name = "kmem_cache",
 };
 
+#define BAD_ALIEN_MAGIC 0x01020304ul
+
 static DEFINE_PER_CPU(struct delayed_work, slab_reap_work);
 
 static inline struct array_cache *cpu_cache_get(struct kmem_cache *cachep)
@@ -836,7 +838,7 @@ static int transfer_objects(struct array
 static inline struct alien_cache **alloc_alien_cache(int node,
 						int limit, gfp_t gfp)
 {
-	return NULL;
+	return (struct alien_cache **)BAD_ALIEN_MAGIC;
 }
 
 static inline void free_alien_cache(struct alien_cache **ac_ptr)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
revert-slab-remove-bad_alien_magic.patch

