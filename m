From: akpm@linux-foundation.org
Subject: + h8300-select-generic-atomic64_t-support.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:21:58 -0700
Message-ID: <20120820212159.27F155C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:62956 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2HTVWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:22:01 -0400
Received: by wgbdt11 with SMTP id dt11so312462wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:22:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, ebiederm@xmission.com, ysato@users.sourceforge.jp


The patch titled
     Subject: h8300: select generic atomic64_t support
has been added to the -mm tree.  Its filename is
     h8300-select-generic-atomic64_t-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: h8300: select generic atomic64_t support

Rationales from Eric:

So I just looked a little deeper and it appears architectures that do
not support atomic64_t are broken.

The generic atomic64 support came in 2009 to support the perf subsystem
with the expectation that all architectures would implement atomic64
support.

Furthermore upon inspection of the kernel atomic64_t is used in a fair
number of places beyond the performance counters:

block/blk-cgroup.c
drivers/acpi/apei/
drivers/block/rbd.c
drivers/crypto/nx/nx.h
drivers/gpu/drm/radeon/radeon.h
drivers/infiniband/hw/ipath/
drivers/infiniband/hw/qib/
drivers/staging/octeon/
fs/xfs/
include/linux/perf_event.h
include/net/netfilter/nf_conntrack_acct.h
kernel/events/
kernel/trace/
net/mac80211/key.h
net/rds/

The block control group, infiniband, xfs, crypto, 802.11, netfilter. 
Nothing quite so fundamental as fs/namespace.c but definitely in
multiplatform-code that should work, and is already broken on those
architecutres.

Looking at the implementation of atomic64_add_return in lib/atomic64.c the
code looks as efficient as these kinds of things get.

Which leads me to the conclusion that we need atomic64 support on all
architectures.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/h8300/Kconfig~h8300-select-generic-atomic64_t-support arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~h8300-select-generic-atomic64_t-support
+++ a/arch/h8300/Kconfig
@@ -3,6 +3,7 @@ config H8300
 	default y
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_ATOMIC64
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch
h8300-select-generic-atomic64_t-support.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
rbtree-performance-and-correctness-test-fix.patch

