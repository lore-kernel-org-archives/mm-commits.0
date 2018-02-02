From: akpm@linux-foundation.org
Subject: + kbuild-always-define-endianess-in-kconfigh.patch added to -mm
 tree
Date: Fri, 02 Feb 2018 11:48:59 -0800
Message-ID: <5a74c0ab.r5BCIG6RPqEd0zCa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753316AbeBBTtB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Feb 2018 14:49:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, ak@linux.intel.com, babu.moger@oracle.com, gregkh@linuxfoundation.org, nico@linaro.org, peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de, will.deacon@arm.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Kbuild: always define endianess in kconfig.h
has been added to the -mm tree.  Its filename is
     kbuild-always-define-endianess-in-kconfigh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kbuild-always-define-endianess-in-kconfigh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kbuild-always-define-endianess-in-kconfigh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: Kbuild: always define endianess in kconfig.h

Build testing with LTO found a couple of files that get compiled
differently depending on whether asm/byteorder.h gets included early
enough or not.  In particular, include/asm-generic/qrwlock_types.h is
affected by this, but there are probably others as well.

The symptom is a series of LTO link time warnings, including these:

net/netlabel/netlabel_unlabeled.h:223: error: type of 'netlbl_unlhsh_add' does not match original declaration [-Werror=lto-type-mismatch]
 int netlbl_unlhsh_add(struct net *net,
net/netlabel/netlabel_unlabeled.c:377: note: 'netlbl_unlhsh_add' was previously declared here

include/net/ipv6.h:360: error: type of 'ipv6_renew_options_kern' does not match original declaration [-Werror=lto-type-mismatch]
 ipv6_renew_options_kern(struct sock *sk,
net/ipv6/exthdrs.c:1162: note: 'ipv6_renew_options_kern' was previously declared here

net/core/dev.c:761: note: 'dev_get_by_name_rcu' was previously declared here
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name)
net/core/dev.c:761: note: code may be misoptimized unless -fno-strict-aliasing is used

drivers/gpu/drm/i915/i915_drv.h:3377: error: type of 'i915_gem_object_set_to_wc_domain' does not match original declaration [-Werror=lto-type-mismatch]
 i915_gem_object_set_to_wc_domain(struct drm_i915_gem_object *obj, bool write);
drivers/gpu/drm/i915/i915_gem.c:3639: note: 'i915_gem_object_set_to_wc_domain' was previously declared here

include/linux/debugfs.h:92:9: error: type of 'debugfs_attr_read' does not match original declaration [-Werror=lto-type-mismatch]
 ssize_t debugfs_attr_read(struct file *file, char __user *buf,
fs/debugfs/file.c:318: note: 'debugfs_attr_read' was previously declared here

include/linux/rwlock_api_smp.h:30: error: type of '_raw_read_unlock' does not match original declaration [-Werror=lto-type-mismatch]
 void __lockfunc _raw_read_unlock(rwlock_t *lock) __releases(lock);
kernel/locking/spinlock.c:246:26: note: '_raw_read_unlock' was previously declared here

include/linux/fs.h:3308:5: error: type of 'simple_attr_open' does not match original declaration [-Werror=lto-type-mismatch]
 int simple_attr_open(struct inode *inode, struct file *file,
fs/libfs.c:795: note: 'simple_attr_open' was previously declared here

All of the above are caused by include/asm-generic/qrwlock_types.h failing
to include asm/byteorder.h after commit e0d02285f16e ("locking/qrwlock:
Use 'struct qrwlock' instead of 'struct __qrwlock'") in linux-4.15.

Similar bugs may or may not exist in older kernels as well, but there is
no easy way to test those with link-time optimizations, and kernels before
4.14 are harder to fix because they don't have Babu's patch series

We had similar issues with CONFIG_ symbols in the past and ended up always
including the configuration headers though linux/kconfig.h.  This works
around the issue through that same file, defining either __BIG_ENDIAN or
__LITTLE_ENDIAN depending on CONFIG_CPU_BIG_ENDIAN, which is now always
set on all architectures since commit 4c97a0c8fee3 ("arch: define
CPU_BIG_ENDIAN for all fixed big endian archs").

Link: http://lkml.kernel.org/r/20180202154104.1522809-2-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Babu Moger <babu.moger@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Nicolas Pitre <nico@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kconfig.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/kconfig.h~kbuild-always-define-endianess-in-kconfigh include/linux/kconfig.h
--- a/include/linux/kconfig.h~kbuild-always-define-endianess-in-kconfigh
+++ a/include/linux/kconfig.h
@@ -4,6 +4,12 @@
 
 #include <generated/autoconf.h>
 
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define __BIG_ENDIAN 4321
+#else
+#define __LITTLE_ENDIAN 1234
+#endif
+
 #define __ARG_PLACEHOLDER_1 0,
 #define __take_second_arg(__ignored, val, ...) val
 
_

Patches currently in -mm which might be from arnd@arndb.de are

locking-qrwlock-include-asm-byteorderh-as-needed.patch
kbuild-always-define-endianess-in-kconfigh.patch
kasan-added-functions-for-unpoisoning-stack-variables-fix-fix.patch
bugh-work-around-gcc-pr82365-in-bug.patch
bitmap-replace-bitmap_fromto_u32array-fix.patch
nilfs2-use-time64_t-internally.patch
pps-parport-use-timespec64-instead-of-timespec.patch
kasan-rework-kconfig-settings.patch

