Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777842673BA
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 20:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747860239; cv=none; b=bzI2X4J6DDxt247Jpal3VxBBHx50rGdbrUURb8aJzw8jz4HEH54GLwdZEWNBcpcKUo/phrccA4s/yTKud36nxy+ExscaO9egp1BqY+zRjlrQp77AHyjdX9spWi7OtUYKP1tyYLw3KSfusm4mOpQrIqYJV/Dyb3yHpEK32+dCgzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747860239; c=relaxed/simple;
	bh=lAla/9QyeVnXQNPU8cD8fkdvfjkDhne+/ZNfnPhCLLQ=;
	h=Date:To:From:Subject:Message-Id; b=peKX6TlbRDOkA49vkdDAUbLLBR2jiyzN6GDnhsOZoIk8oRnKSNn71hhRPkfadiJ051gvn9PQMneREV7MIPWgmmaWxM7jSzGbcEbFIHUcsLWB1rQLZUL/APa1O5Ld4oowo767oYBokHJT2WUr9KNdsi+spQCpZXGvPrDKJDrc2MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i36GcuoC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i36GcuoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148DCC4CEE4;
	Wed, 21 May 2025 20:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747860239;
	bh=lAla/9QyeVnXQNPU8cD8fkdvfjkDhne+/ZNfnPhCLLQ=;
	h=Date:To:From:Subject:From;
	b=i36GcuoCF2XA4nSrngL+AJTBjsmyNNlo18ab/ZxpMS8IzMlFCI3hNv6LuFA/WISku
	 TU/GfeEL7ib1B7W9IKFx5f+A2WJnUYkjGcZKDMeqiv902TmgcIL+qWGZdVxR3SkyX+
	 454z/8ybSB32Q16x6VDUQ7G3TlBCWt/JbhuTeedk=
Date: Wed, 21 May 2025 13:43:58 -0700
To: mm-commits@vger.kernel.org,sagi@grimberg.me,leitao@debian.org,kch@nvidia.com,hch@lst.de,coxu@redhat.com,axboe@kernel.dk,a.hindborg@kernel.org,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-nvme-select-configfs_fs-as-built-in.patch added to mm-nonmm-unstable branch
Message-Id: <20250521204359.148DCC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump, nvme: select CONFIGFS_FS as built-in
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-nvme-select-configfs_fs-as-built-in.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-nvme-select-configfs_fs-as-built-in.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: crash_dump, nvme: select CONFIGFS_FS as built-in
Date: Wed, 21 May 2025 18:03:19 +0200

Configfs can be configured as a loadable module, which causes a link-time
failure for dm-crypt crash dump support:

crash_dump_dm_crypt.c:(.text+0x3a4): undefined reference to `config_item_init_type_name'
aarch64-linux-ld: kernel/crash_dump_dm_crypt.o: in function `configfs_dmcrypt_keys_init':
crash_dump_dm_crypt.c:(.init.text+0x90): undefined reference to `config_group_init'
aarch64-linux-ld: crash_dump_dm_crypt.c:(.init.text+0xb4): undefined reference to `configfs_register_subsystem'
aarch64-linux-ld: crash_dump_dm_crypt.c:(.init.text+0xd8): undefined reference to `configfs_unregister_subsystem'

This could be avoided with a dependency on CONFIGFS_FS=y, but the
dependency has an additional problem of causing Kconfig dependency loops
since most other uses select the symbol.

Using a simple 'select CONFIGFS_FS' here in turn fails with
CONFIG_DM_CRYPT=m, because that still only causes configfs to be a
loadable module.

The only version I found that fixes this reliably uses an additional
Kconfig symbol to ensure the 'select' actually turns on configfs as
builtin, with two additional changes to avoid dependency loops with nvme
and sysfs.

There is no compile-time dependency between configfs and sysfs, so
selecting configfs from a driver with sysfs disabled does not cause link
failures, only the default /sys/kernel/config mount point will not be
created.

Link: https://lkml.kernel.org/r/20250521160359.2132363-1-arnd@kernel.org
Fixes: 6b23858fd63b ("crash_dump: make dm crypt keys persist for the kdump kernel")
Fixes: 1fb470408497 ("nvme-loop: add configfs dependency")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvme/target/Kconfig |    2 +-
 fs/configfs/Kconfig         |    1 -
 kernel/Kconfig.kexec        |    8 +++++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/nvme/target/Kconfig~crash_dump-nvme-select-configfs_fs-as-built-in
+++ a/drivers/nvme/target/Kconfig
@@ -3,7 +3,7 @@
 config NVME_TARGET
 	tristate "NVMe Target support"
 	depends on BLOCK
-	depends on CONFIGFS_FS
+	select CONFIGFS_FS
 	select NVME_KEYRING if NVME_TARGET_TCP_TLS
 	select KEYS if NVME_TARGET_TCP_TLS
 	select SGL_ALLOC
--- a/fs/configfs/Kconfig~crash_dump-nvme-select-configfs_fs-as-built-in
+++ a/fs/configfs/Kconfig
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem"
-	select SYSFS
 	help
 	  configfs is a RAM-based filesystem that provides the converse
 	  of sysfs's functionality. Where sysfs is a filesystem-based
--- a/kernel/Kconfig.kexec~crash_dump-nvme-select-configfs_fs-as-built-in
+++ a/kernel/Kconfig.kexec
@@ -134,12 +134,18 @@ config CRASH_DM_CRYPT
 	depends on KEXEC_FILE
 	depends on CRASH_DUMP
 	depends on DM_CRYPT
-	depends on CONFIGFS_FS
 	help
 	  With this option enabled, user space can intereact with
 	  /sys/kernel/config/crash_dm_crypt_keys to make the dm crypt keys
 	  persistent for the dump-capture kernel.
 
+config CRASH_DM_CRYPT_CONFIGS
+	def_tristate CRASH_DM_CRYPT
+	select CONFIGFS_FS
+	help
+	  CRASH_DM_CRYPT cannot directly select CONFIGFS_FS, because that
+	  is required to be built-in.
+
 config CRASH_HOTPLUG
 	bool "Update the crash elfcorehdr on system configuration changes"
 	default y
_

Patches currently in -mm which might be from arnd@arndb.de are

crash_dump-nvme-select-configfs_fs-as-built-in.patch

