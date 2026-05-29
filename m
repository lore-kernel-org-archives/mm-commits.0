Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D7B372662
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028748; cv=none; b=TNxrGu9PzU0BIP29cnU/z1ixRFVihYARIJrbfEHOWnuGljEswW7v3RQr13NsCDKhlP+UoTTFjelV0I67zEEqquGK+mbEwiCGC+uAb6l5xynlC+eKASv8JMULJm+l2N1PIC6sy/nYJjN3XdpOGrk4W3ZuO9IzHt9Xpe5vOl+ff4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028748; c=relaxed/simple;
	bh=YrW8aAKeqzCXuou/72var5flZA86unIHGu6H0ihN7/E=;
	h=Date:To:From:Subject:Message-Id; b=PNKATxBQXXNmOP/ejHAJJt+jJ4rQeQS6PFxk0g+5Dns98QzsVKaNZSAOER/HvynOVKH/o48XrPUZIxMedivrn9vfTlTRkyL1I+ldpvJFtYs+vzNUE+fOp5NP014QxpRnPqsfoz2h0edBOHyCuiyVRAtde+LNp+lqB632pc5ln10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rW5SllYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rW5SllYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC451F00893;
	Fri, 29 May 2026 04:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028745;
	bh=SvpuQDw58HkaBBqkLcvP52BBdo5VDAGnzVZ0C3FXuaY=;
	h=Date:To:From:Subject;
	b=rW5SllYO18/TgdEWoFYn3qM4aEGhRYxhDSZb4LSnIH4tSLG1Os6mlBAkbQ6OeRb/Y
	 NmF5Y/3toX9w/5rC4nhVRqFBuMO9Wq28wwBIM7miuPMdV6BAliT1UgmGN18GBg6cER
	 w/lZvsFt8BFH8mRjhknzLxKzqL0friSYhqpHKHJM=
Date: Thu, 28 May 2026 21:25:45 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,Liam.Howlett@oracle.com,jack@suse.cz,brauner@kernel.org,linux.amoon@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] treewide-fix-indentation-and-whitespace-in-kconfig-files.patch removed from -mm tree
Message-Id: <20260529042545.CFC451F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: treewide: fix indentation and whitespace in Kconfig files
has been removed from the -mm tree.  Its filename was
     treewide-fix-indentation-and-whitespace-in-kconfig-files.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anand Moon <linux.amoon@gmail.com>
Subject: treewide: fix indentation and whitespace in Kconfig files
Date: Tue, 7 Apr 2026 11:09:34 +0530

Clean up inconsistent indentation (mixing tabs and spaces) and remove
extraneous whitespace in several Kconfig files across the tree.  This is a
purely cosmetic change to improve readability.

Adjust indentation from spaces to tab (+optional two spaces) as in
coding style with command like:

$ sed -e 's/^        /\t/' -i */Kconfig

Link: https://lore.kernel.org/20260407053945.14116-1-linux.amoon@gmail.com
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>			[fs]
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>	[mm]
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>		[mm]
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 certs/Kconfig |   14 +++++++-------
 fs/Kconfig    |    6 +++---
 init/Kconfig  |   24 ++++++++++++------------
 lib/Kconfig   |    2 +-
 mm/Kconfig    |    4 ++--
 5 files changed, 25 insertions(+), 25 deletions(-)

--- a/certs/Kconfig~treewide-fix-indentation-and-whitespace-in-kconfig-files
+++ a/certs/Kconfig
@@ -6,14 +6,14 @@ config MODULE_SIG_KEY
 	default "certs/signing_key.pem"
 	depends on MODULE_SIG || (IMA_APPRAISE_MODSIG && MODULES)
 	help
-         Provide the file name of a private key/certificate in PEM format,
-         or a PKCS#11 URI according to RFC7512. The file should contain, or
-         the URI should identify, both the certificate and its corresponding
-         private key.
+	 Provide the file name of a private key/certificate in PEM format,
+	 or a PKCS#11 URI according to RFC7512. The file should contain, or
+	 the URI should identify, both the certificate and its corresponding
+	 private key.
 
-         If this option is unchanged from its default "certs/signing_key.pem",
-         then the kernel will automatically generate the private key and
-         certificate as described in Documentation/admin-guide/module-signing.rst
+	 If this option is unchanged from its default "certs/signing_key.pem",
+	 then the kernel will automatically generate the private key and
+	 certificate as described in Documentation/admin-guide/module-signing.rst
 
 choice
 	prompt "Type of module signing key to be generated"
--- a/fs/Kconfig~treewide-fix-indentation-and-whitespace-in-kconfig-files
+++ a/fs/Kconfig
@@ -78,7 +78,7 @@ config FS_DAX
 	  --map=mem:
 	  https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace
 
-          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
+	  For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
 	  file systems DAX support needs to be manually enabled globally or
 	  per-inode using a mount option as well.  See the file documentation in
 	  Documentation/filesystems/dax.rst for details.
@@ -116,8 +116,8 @@ config FILE_LOCKING
 	default y
 	help
 	  This option enables standard file locking support, required
-          for filesystems like NFS and for the flock() system
-          call. Disabling this option saves about 11k.
+	  for filesystems like NFS and for the flock() system
+	  call. Disabling this option saves about 11k.
 
 source "fs/crypto/Kconfig"
 
--- a/init/Kconfig~treewide-fix-indentation-and-whitespace-in-kconfig-files
+++ a/init/Kconfig
@@ -1050,14 +1050,14 @@ config PAGE_COUNTER
 	bool
 
 config CGROUP_FAVOR_DYNMODS
-        bool "Favor dynamic modification latency reduction by default"
-        help
-          This option enables the "favordynmods" mount option by default
-          which reduces the latencies of dynamic cgroup modifications such
-          as task migrations and controller on/offs at the cost of making
-          hot path operations such as forks and exits more expensive.
+	bool "Favor dynamic modification latency reduction by default"
+	help
+	  This option enables the "favordynmods" mount option by default
+	  which reduces the latencies of dynamic cgroup modifications such
+	  as task migrations and controller on/offs at the cost of making
+	  hot path operations such as forks and exits more expensive.
 
-          Say N if unsure.
+	  Say N if unsure.
 
 config MEMCG
 	bool "Memory controller"
@@ -1139,7 +1139,7 @@ config GROUP_SCHED_WEIGHT
 	def_bool n
 
 config GROUP_SCHED_BANDWIDTH
-        def_bool n
+	def_bool n
 
 config FAIR_GROUP_SCHED
 	bool "Group scheduling for SCHED_OTHER"
@@ -1645,10 +1645,10 @@ config LD_ORPHAN_WARN
 	depends on $(ld-option,--orphan-handling=error)
 
 config LD_ORPHAN_WARN_LEVEL
-        string
-        depends on LD_ORPHAN_WARN
-        default "error" if WERROR
-        default "warn"
+	string
+	depends on LD_ORPHAN_WARN
+	default "error" if WERROR
+	default "warn"
 
 config SYSCTL
 	bool
--- a/lib/Kconfig~treewide-fix-indentation-and-whitespace-in-kconfig-files
+++ a/lib/Kconfig
@@ -590,7 +590,7 @@ config OBJAGG
 config LWQ_TEST
 	bool "Boot-time test for lwq queuing"
 	help
-          Run boot-time test of light-weight queuing.
+	  Run boot-time test of light-weight queuing.
 
 endmenu
 
--- a/mm/Kconfig~treewide-fix-indentation-and-whitespace-in-kconfig-files
+++ a/mm/Kconfig
@@ -1303,7 +1303,7 @@ config ARCH_HAS_PTE_SPECIAL
 	bool
 
 config MAPPING_DIRTY_HELPERS
-        bool
+	bool
 
 config KMAP_LOCAL
 	bool
@@ -1434,7 +1434,7 @@ config ARCH_HAS_USER_SHADOW_STACK
 	bool
 	help
 	  The architecture has hardware support for userspace shadow call
-          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
+	  stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
 config HAVE_ARCH_TLB_REMOVE_TABLE
 	def_bool n
_

Patches currently in -mm which might be from linux.amoon@gmail.com are


