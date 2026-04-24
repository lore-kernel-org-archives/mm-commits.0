Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893423E8C67
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777056790; cv=none; b=VjksC57ARR4ZIw3ypAo93/cQRVipp0yDVdgopzC6f3onIO+LUgFBjCzhombPyCaOnyxsoouwgYJsOr+wfNq2WRKraq4K8wJnltgBpJvq+dz6QAGJWbPMykd7Ep+wQcuQnRkmsiBP3FAHgb96sUguMTPGUP52pj7PdoH+08xwKVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777056790; c=relaxed/simple;
	bh=lbhEPrPSnaFf+7twnwfYJ/fCBO+4xLS6NIQgkhiU4tI=;
	h=Date:To:From:Subject:Message-Id; b=qjgrvsIA81KgxdHldCFii1dlUQdpAc1F75qnZDFvaZKN4GoJbGD85/x5cMJ1kEMxQ8PgK0uli9htOdTvIXE0dmvs21qZLyyFaa9v1pJdfEi/P/0YKraFvTBvpshj/EiAre+5SQt/zNCJVCVJ00Xo0vStD6xwhLz4h5tSgpzZHlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FvHs1M8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FvHs1M8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220DCC19425;
	Fri, 24 Apr 2026 18:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777056790;
	bh=lbhEPrPSnaFf+7twnwfYJ/fCBO+4xLS6NIQgkhiU4tI=;
	h=Date:To:From:Subject:From;
	b=FvHs1M8EsZkuVEYNug45sJzn00oebZ/NMRkXBZnfTjtUFvCtUPTKis7F+qXJXVI/a
	 BN/e/4eQJLdj6BFPxKaEVnL69/IthccjhcmiEdwpPtzM8VDb0C0a116FAuIfrt+bjA
	 QgQMD9m1xLlaC4l4MjWv87/EsZ28+73IygQPhJDM=
Date: Fri, 24 Apr 2026 11:53:09 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,Liam.Howlett@oracle.com,jack@suse.cz,brauner@kernel.org,linux.amoon@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + treewide-fix-indentation-and-whitespace-in-kconfig-files.patch added to mm-nonmm-unstable branch
Message-Id: <20260424185310.220DCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: treewide: fix indentation and whitespace in Kconfig files
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     treewide-fix-indentation-and-whitespace-in-kconfig-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/treewide-fix-indentation-and-whitespace-in-kconfig-files.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -1291,7 +1291,7 @@ config ARCH_HAS_PTE_SPECIAL
 	bool
 
 config MAPPING_DIRTY_HELPERS
-        bool
+	bool
 
 config KMAP_LOCAL
 	bool
@@ -1422,7 +1422,7 @@ config ARCH_HAS_USER_SHADOW_STACK
 	bool
 	help
 	  The architecture has hardware support for userspace shadow call
-          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
+	  stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
 config HAVE_ARCH_TLB_REMOVE_TABLE
 	def_bool n
_

Patches currently in -mm which might be from linux.amoon@gmail.com are

treewide-fix-indentation-and-whitespace-in-kconfig-files.patch

