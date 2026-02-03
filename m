Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C693287276
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 02:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770086676; cv=none; b=XqKwYu54hIzBsb1gKp5+UjHFOmXbIIvhcCD5MDGZ61DMsoPTzVQZSu6e4wkEaUlPtQyqI+cpVqTxBR5793au0h6rNovovKNv96QLMOwOMdleGCEQqXv5g6vgSX7LK914Xn/kPyeNQre9fV+xzP8Q0txYfZ5i5SR4y3QbI2ct6pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770086676; c=relaxed/simple;
	bh=a+gdaBTU05Ow6sdzjvlBvi/9+wy27+WYSjW9o0fZBt8=;
	h=Date:To:From:Subject:Message-Id; b=bUrzZz8GM3T05jPYB91AjYJDESLCXV2ItYrIIr84TWuht0MT0z5uu9t1fqwFpzEwDR8+SOa8fS7MDhI7HXN/2DZeRMPHLHjUhbeJ/+ZASEDWSzVxhXV6/q0HB8RgX8WM0Ns9vyaDhMkMo1G7fTwfoa2ZWMB4BijwXEZ9Hn1LraI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PciJBmBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PciJBmBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98D2C116C6;
	Tue,  3 Feb 2026 02:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086675;
	bh=a+gdaBTU05Ow6sdzjvlBvi/9+wy27+WYSjW9o0fZBt8=;
	h=Date:To:From:Subject:From;
	b=PciJBmBEYxqa4XZGMHWBLPn+jOcVeV7LmJNt0Mol91aCGzbdJRpbCEf2GJoaXlElS
	 M+s2BMXAQhTcqsq8BfockdEu6XDwdDapLXNVdUBKX7JqdHeUmnhSsTR/7b4gfRuJ7b
	 XPrFUd/IOtyeKqKB03cgQSWUKLH2t2qve5RQS9S0=
Date: Mon, 02 Feb 2026 18:44:35 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,ptyadav@amazon.de,pawan.kumar.gupta@linux.intel.com,pasha.tatashin@soleen.com,mingo@kernel.org,lirongqing@baidu.com,kees@kernel.org,fvdl@google.com,corbet@lwn.net,bp@alien8.de,arnd@arndb.de,me@linux.beauty,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] documentation-document-liveupdate-cmdline-parameter.patch removed from -mm tree
Message-Id: <20260203024435.D98D2C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Documentation: document liveupdate cmdline parameter
has been removed from the -mm tree.  Its filename was
     documentation-document-liveupdate-cmdline-parameter.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Li Chen <me@linux.beauty>
Subject: Documentation: document liveupdate cmdline parameter
Date: Fri, 30 Jan 2026 19:20:33 +0800

liveupdate is used to enable Live Update Orchestrator (LUO) early during
boot.  Add it to kernel-parameters.txt so users can discover and use it.

Link: https://lkml.kernel.org/r/20260130112036.359806-1-me@linux.beauty
Signed-off-by: Li Chen <me@linux.beauty>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Li RongQing <lirongqing@baidu.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~documentation-document-liveupdate-cmdline-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -3472,6 +3472,11 @@ Kernel parameters
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	liveupdate=	[KNL,EARLY]
+			Format: <bool>
+			Enable Live Update Orchestrator (LUO).
+			Default: off.
+
 	load_ramdisk=	[RAM] [Deprecated]
 
 	lockd.nlm_grace_period=P  [NFS] Assign grace period.
_

Patches currently in -mm which might be from me@linux.beauty are


