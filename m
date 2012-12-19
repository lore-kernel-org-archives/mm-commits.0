From: akpm@linux-foundation.org
Subject: [merged] h8300-select-generic-atomic64_t-support.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:39:39 -0800
Message-ID: <20121219203939.B8B8282004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48354 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab2LSUjk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:39:40 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so277698ggn.3
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:39:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, ebiederm@xmission.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: h8300: select generic atomic64_t support
has been removed from the -mm tree.  Its filename was
     h8300-select-generic-atomic64_t-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch

