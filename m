From: akpm@linux-foundation.org
Subject: [merged]
 mm-allow-slab_nomerge-to-be-set-at-build-time.patch removed from -mm tree
Date: Fri, 07 Jul 2017 12:08:06 -0700
Message-ID: <20170707190806.ExsEttMmb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGTII (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:08:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, bigeasy@linutronix.de, cl@linux.com, corbet@lwn.net, daniel@zonque.org, danielmicay@gmail.com, dave@nullcore.net, deller@gmx.de, ebiggers3@gmail.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, luto@kernel.org, mchehab@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, nicolas.pitre@linaro.org, paulmck@linux.vnet.ibm.com, penberg@kernel.org, rafael.j.wysocki@intel.com, rdunlap@infradead.org, riel@redhat.com, rientjes@google.com, sergey.senozhatsky@gmail.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     Subject: mm: allow slab_nomerge to be set at build time
has been removed from the -mm tree.  Its filename was
     mm-allow-slab_nomerge-to-be-set-at-build-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: allow slab_nomerge to be set at build time

Some hardened environments want to build kernels with slab_nomerge
already set (so that they do not depend on remembering to set the kernel
command line option). This is desired to reduce the risk of kernel heap
overflows being able to overwrite objects from merged caches and changes
the requirements for cache layout control, increasing the difficulty of
these attacks. By keeping caches unmerged, these kinds of exploits can
usually only damage objects in the same cache (though the risk to metadata
exploitation is unchanged).

Link: http://lkml.kernel.org/r/20170620230911.GA25238@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Windsor <dave@nullcore.net>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Windsor <dave@nullcore.net>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Daniel Mack <daniel@zonque.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   10 ++++++++--
 init/Kconfig                                    |   14 ++++++++++++++
 mm/slab_common.c                                |    5 ++---
 3 files changed, 24 insertions(+), 5 deletions(-)

diff -puN Documentation/admin-guide/kernel-parameters.txt~mm-allow-slab_nomerge-to-be-set-at-build-time Documentation/admin-guide/kernel-parameters.txt
--- a/Documentation/admin-guide/kernel-parameters.txt~mm-allow-slab_nomerge-to-be-set-at-build-time
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3760,8 +3760,14 @@
 	slab_nomerge	[MM]
 			Disable merging of slabs with similar size. May be
 			necessary if there is some reason to distinguish
-			allocs to different slabs. Debug options disable
-			merging on their own.
+			allocs to different slabs, especially in hardened
+			environments where the risk of heap overflows and
+			layout control by attackers can usually be
+			frustrated by disabling merging. This will reduce
+			most of the exposure of a heap attack to a single
+			cache (risks via metadata attacks are mostly
+			unchanged). Debug options disable merging on their
+			own.
 			For more information see Documentation/vm/slub.txt.
 
 	slab_max_order=	[MM, SLAB]
diff -puN init/Kconfig~mm-allow-slab_nomerge-to-be-set-at-build-time init/Kconfig
--- a/init/Kconfig~mm-allow-slab_nomerge-to-be-set-at-build-time
+++ a/init/Kconfig
@@ -1548,6 +1548,20 @@ config SLOB
 
 endchoice
 
+config SLAB_MERGE_DEFAULT
+	bool "Allow slab caches to be merged"
+	default y
+	help
+	  For reduced kernel memory fragmentation, slab caches can be
+	  merged when they share the same size and other characteristics.
+	  This carries a risk of kernel heap overflows being able to
+	  overwrite objects from merged caches (and more easily control
+	  cache layout), which makes such heap attacks easier to exploit
+	  by attackers. By keeping caches unmerged, these kinds of exploits
+	  can usually only damage objects in the same cache. To disable
+	  merging at runtime, "slab_nomerge" can be passed on the kernel
+	  command line.
+
 config SLAB_FREELIST_RANDOM
 	default n
 	depends on SLAB || SLUB
diff -puN mm/slab_common.c~mm-allow-slab_nomerge-to-be-set-at-build-time mm/slab_common.c
--- a/mm/slab_common.c~mm-allow-slab_nomerge-to-be-set-at-build-time
+++ a/mm/slab_common.c
@@ -47,13 +47,12 @@ static DECLARE_WORK(slab_caches_to_rcu_d
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
- * (Could be removed. This was introduced to pacify the merge skeptics.)
  */
-static int slab_nomerge;
+static bool slab_nomerge = !IS_ENABLED(CONFIG_SLAB_MERGE_DEFAULT);
 
 static int __init setup_slab_nomerge(char *str)
 {
-	slab_nomerge = 1;
+	slab_nomerge = true;
 	return 1;
 }
 
_

Patches currently in -mm which might be from keescook@chromium.org are

binfmt_elf-use-elf_et_dyn_base-only-for-pie.patch
arm-reduce-elf_et_dyn_base.patch
arm64-move-elf_et_dyn_base-to-4gb-4mb.patch
powerpc-reduce-elf_et_dyn_base.patch
s390-reduce-elf_et_dyn_base.patch
binfmt_elf-safely-increment-argv-pointers.patch
random-do-not-ignore-early-device-randomness.patch
ipc-drop-non-rcu-allocation.patch
ipc-sem-do-not-use-ipc_rcu_free.patch
ipc-shm-do-not-use-ipc_rcu_free.patch
ipc-msg-do-not-use-ipc_rcu_free.patch
ipc-util-drop-ipc_rcu_free.patch
ipc-sem-avoid-ipc_rcu_alloc.patch
ipc-shm-avoid-ipc_rcu_alloc.patch
ipc-msg-avoid-ipc_rcu_alloc.patch
ipc-util-drop-ipc_rcu_alloc.patch
ipc-move-atomic_set-to-where-it-is-needed.patch
ipc-shm-remove-special-shm_alloc-free.patch
ipc-msg-remove-special-msg_alloc-free.patch
ipc-sem-drop-__sem_free.patch
efi-avoid-fortify-checks-in-efi-stub.patch
kexec_file-adjust-declaration-of-kexec_purgatory.patch
ib-rxe-do-not-copy-extra-stack-memory-to-skb.patch
include-linux-stringh-add-the-option-of-fortified-stringh-functions-fix-2.patch
sh-mark-end-of-bug-implementation-as-unreachable.patch

