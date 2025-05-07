Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A51494DB
	for <mm-commits@vger.kernel.org>; Wed,  7 May 2025 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746581970; cv=none; b=czAdlBCcTA8opZOsggDyL5bX+vApJ0NTWwGZgcTNgjpizd7tNWewn9aKLZF4/j24mBBy9CvtrWp7xfxpY6+aISox+Cp8ESZkineUkP0Jm4LhAHAi+XxWZ8v8171fRTsK4cGrUfE4gDKcvaO3x5eGN2Rs+/37xa8AFyzXhjMunC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746581970; c=relaxed/simple;
	bh=CHozxv84qnE4prh0rEAZ/RovkHCmVdweogQu8wplBRM=;
	h=Date:To:From:Subject:Message-Id; b=VJW8QGmGqHJzP/OHsvSCh5kwxGr0FBcd9cBTx3AtFUJuqvwO/cq5LAVhO5GMkZQcEY3/49b48zJ4oRZwgR3TL/suWCiYO1oVfE0RQVdprtBJxKrNqhfzuGSKHoxdGSW3qF4xZyOLbvpaq2JRXVbJOnEKAXM3z9/X8sBza/8i3vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HCHm+ZqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HCHm+ZqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4A5C4CEE4;
	Wed,  7 May 2025 01:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746581970;
	bh=CHozxv84qnE4prh0rEAZ/RovkHCmVdweogQu8wplBRM=;
	h=Date:To:From:Subject:From;
	b=HCHm+ZqF+8adaVK09IAyw4F18316Iaw1pgV7FxrT7jdWVTLPUdhOF6NTjgr8T4BEU
	 sgWxouQT3a6s9JVRG2UL+4HVKNpAeY3f+dEkCjeAIJKdLiFvWZVqOM01ZjIs+eirO8
	 lyr1tBw992O243W/2S79jkGm+iLsgy3U7pLjaC5I=
Date: Tue, 06 May 2025 18:39:29 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,corbet@lwn.net,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] documentation-kernel-parameters-update-memtest-parameter.patch removed from -mm tree
Message-Id: <20250507013930.0D4A5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation/kernel-parameters: update memtest parameter
has been removed from the -mm tree.  Its filename was
     documentation-kernel-parameters-update-memtest-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: Documentation/kernel-parameters: update memtest parameter
Date: Mon, 28 Apr 2025 11:47:46 +0800

LoongArch, MIPS and XTENSA has supported memtest now.
Update documentation for them.

Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=dce44566192ec0b38597fdfd435013c2d54653ff
Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb8e9f59d6f292c3d9fea6c155c22ea5fc3053ab
Link: https://lkml.kernel.org/r/0FC3D21CA22E8251+20250428034746.21216-1-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~documentation-kernel-parameters-update-memtest-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3620,7 +3620,7 @@
 			Note that even when enabled, there are a few cases where
 			the feature is not effective.
 
-	memtest=	[KNL,X86,ARM,M68K,PPC,RISCV,EARLY] Enable memtest
+	memtest=	[KNL,X86,ARM,LOONGARCH,MIPS,M68K,PPC,RISCV,XTENSA,EARLY] Enable memtest
 			Format: <integer>
 			default : 0 <disable>
 			Specifies the number of memtest passes to be
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

ocfs2-o2net_idle_timer-rename-del_timer_sync-in-comment.patch
treewide-fix-typo-previlege.patch

