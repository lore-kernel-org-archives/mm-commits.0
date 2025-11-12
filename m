Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560761F03D7
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 00:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762908305; cv=none; b=SwInUfQq9AcbcozoBNWvF8evO8bFmhhtJp/+v1uw4wlZmOOsLfVhlumKU+XYa6ap0rXI/6KB14xLAyxUF0aQveSySv+dEZJgHqQzuWayLmZbyPT1bYviXiIYyYCYS5FpymWRaAUyx2EoD+GS6F0gHrF7aXr+uR6+FPmyNsIGufA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762908305; c=relaxed/simple;
	bh=QdYg5gHH2KqaS7OsJgYz6sx3TDMBoyVt4Bina4iivnc=;
	h=Date:To:From:Subject:Message-Id; b=FFyVjogF9E/1usUul3zcgs6lvGpdMd9cKMAYv9A+Xvc1judXmOIKHj7NjoW3gehEhZz4EqswbhxlGBNeS+d6IdZtZkR/gM4BPsKKptpLTZxsKmUY/9t1pXsZRGPXQtDLlj8J32l+1DHYL03iXuSu9vxblgIV2FimTFt79dd7Ux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PTynV6lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PTynV6lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97EEC4CEFB;
	Wed, 12 Nov 2025 00:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762908304;
	bh=QdYg5gHH2KqaS7OsJgYz6sx3TDMBoyVt4Bina4iivnc=;
	h=Date:To:From:Subject:From;
	b=PTynV6lbcV+cnMQ66AoWBH+E/7nI0N/MYcTXhd4FVI4XKJgjh0IFHwRjlYAq8iZQe
	 K18Vl20lWwC4xJaQLoAgw9mxhw30lAYHmfnNlg1EbTpp3ZkPPk2zXUCvbu1cGm4IKH
	 DnURP4kw82zqztthPDli/8Yythr0Aq+5OxGlQGxQ=
Date: Tue, 11 Nov 2025 16:45:03 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,shakeel.butt@linux.dev,rppt@kernel.org,rdunlap@infradead.org,peterz@infradead.org,paulmck@kernel.org,ojeda@kernel.org,nathan@kernel.org,mkoutny@suse.com,mingo@kernel.org,masahiroy@kernel.org,kernel@jfarr.cc,kees@kernel.org,jeffxu@chromium.org,hca@linux.ibm.com,guoweikang.kernel@gmail.com,geert@linux-m68k.org,francesco@valla.it,dianders@chromium.org,chenhuacai@kernel.org,brgerst@gmail.com,brauner@kernel.org,alexander.shishkin@linux.intel.com,achant@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch removed from -mm tree
Message-Id: <20251112004504.B97EEC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix
has been removed from the -mm tree.  Its filename was
     init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix.patch

This patch was dropped because it was folded into init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix
Date: Thu Oct 23 12:32:59 PM PDT 2025

make print_kernel_cmdline __init

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Chant <achant@google.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Francesco Valla <francesco@valla.it>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Hendrik Farr <kernel@jfarr.cc>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs-fix
+++ a/init/main.c
@@ -944,7 +944,7 @@ static void __init early_numa_node_init(
  *   Kernel command line: jumps over the \
  *   Kernel command line: lazy dog."
  */
-static void print_kernel_cmdline(const char *cmdline)
+static void __init print_kernel_cmdline(const char *cmdline)
 {
 	size_t len;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-remove-folio_test_private-check-in-pageout-fix.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd-fix.patch
mm-huge_memory-introduce-enum-split_type-for-clarity-fix.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix-fix.patch
init-mainc-wrap-long-kernel-cmdline-when-printing-to-logs.patch
panic-sys_info-factor-out-read-and-write-handlers-checkpatch-fixes.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
liveupdate-luo_file-implement-file-systems-callbacks-fix.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags-fix.patch

