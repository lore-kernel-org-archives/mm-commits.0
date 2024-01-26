Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B58ED310;
	Fri, 26 Jan 2024 07:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255748; cv=none; b=lVfTf0cJzB001DZ1YCuE/sEZcXuuvtNk0IDI8M2x9riNH3jF8wQhLENzHPX+fkUebeUP3O0QSEKVx7bKvx1eDG7bUmKTB2C3kWKzyzerVzbcBHdHNI4xdnhMTUyCe6FxnSRxcD1HO6GGdVQCS6K6g5kZIfMilJFAJ0w55306Y04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255748; c=relaxed/simple;
	bh=48zko/Uq/xju7EdHq660h8kS2uU3R7BvrXHmtqurNBQ=;
	h=Date:To:From:Subject:Message-Id; b=U5B0GykHUKd8bWI+2hd64x2KldaKM/4flTwS4NrHWBt2IhqMYqhtAOSvz1EkVXCdwU+3AnoIwVfAO011873ms9c9TV+ITxcJLCxyeCwjkaJifLkBqEyzxFPyfRKtlDLDTzCMgxQhaRvr+A2NkukYor0vNvWmAiam/2nqCITGBgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D+8A55Kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D+8A55Kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B410C433C7;
	Fri, 26 Jan 2024 07:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255747;
	bh=48zko/Uq/xju7EdHq660h8kS2uU3R7BvrXHmtqurNBQ=;
	h=Date:To:From:Subject:From;
	b=D+8A55KdvT2oXxsQh+F9jLbv0JJH3saV3alIGAto7L5CjSYU7sz6gmuAW0A235c6D
	 UxV1R5TZErzdIzwnrUXPycKS1ZQiMCmll63A/8tXUNeExY1mPZ3FR0KHLikC0Cudbt
	 +RDPk5GKjgYBK1392mXXWkLwAh4xDw7AnxOkSQcs=
Date: Thu, 25 Jan 2024 23:55:44 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,samitolvanen@google.com,samuel.holland@sifive.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scs-add-config_mmu-dependency-for-vfree_atomic.patch removed from -mm tree
Message-Id: <20240126075547.7B410C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scs: add CONFIG_MMU dependency for vfree_atomic()
has been removed from the -mm tree.  Its filename was
     scs-add-config_mmu-dependency-for-vfree_atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Samuel Holland <samuel.holland@sifive.com>
Subject: scs: add CONFIG_MMU dependency for vfree_atomic()
Date: Mon, 22 Jan 2024 09:52:01 -0800

The shadow call stack implementation fails to build without CONFIG_MMU:

  ld.lld: error: undefined symbol: vfree_atomic
  >>> referenced by scs.c
  >>>               kernel/scs.o:(scs_free) in archive vmlinux.a

Link: https://lkml.kernel.org/r/20240122175204.2371009-1-samuel.holland@sifive.com
Fixes: a2abe7cbd8fe ("scs: switch to vmapped shadow stacks")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/Kconfig~scs-add-config_mmu-dependency-for-vfree_atomic
+++ a/arch/Kconfig
@@ -673,6 +673,7 @@ config SHADOW_CALL_STACK
 	bool "Shadow Call Stack"
 	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
 	depends on DYNAMIC_FTRACE_WITH_ARGS || DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
+	depends on MMU
 	help
 	  This option enables the compiler's Shadow Call Stack, which
 	  uses a shadow stack to protect function return addresses from
_

Patches currently in -mm which might be from samuel.holland@sifive.com are


