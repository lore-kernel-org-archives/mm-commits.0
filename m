Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6AA1EF091
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 22:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763676278; cv=none; b=Gmp605WaoZ3a0VnvdjIn9eA6xj6RGh8U/NodmY4DeLm1IedQlhALbPpgSJYmwQ8IkNMsMfb5UNZ6j9KuLR6M5ot5nSVUBAIVUdLMGEDPGhWSvFI/1FWAmdGjjsnRFF7FuDhnoqxnRt1myLawNl89Q1zTFy5Jva7xF7E9NlQOio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763676278; c=relaxed/simple;
	bh=7BRAJZWn/A4+n3/YkJsr4GL8yIOsqbsajGH7q2j1jlw=;
	h=Date:To:From:Subject:Message-Id; b=HLspp7ecfP2XkiGsr/sDOV6dyv6fp94GzwVsrPq1KOKwd41qAu6E7B4sG5NDquywWi8v1N4Ml4NAvmF4gKkWqWWeXGQ03lzKmdzUgk1oGzxvlXwRaLa74Z7+LrMy87b6jNVGHl7oFh223pojEO1WIRfgjKkafmpA6j0zXFFgiL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ytJxTEDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ytJxTEDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B67FC4CEF1;
	Thu, 20 Nov 2025 22:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763676278;
	bh=7BRAJZWn/A4+n3/YkJsr4GL8yIOsqbsajGH7q2j1jlw=;
	h=Date:To:From:Subject:From;
	b=ytJxTEDl8koG8sDQ/qss9lmP4tIK+y4C1r7rX8dIQLfmE//044o4ofAyymlpMd9Ny
	 6V0Mr6yQ4xtC+48U6tBaXPCYbZ2VtPNETkltDX6Npxg0evYGSSHhXbogp5sNt0JCtF
	 GQP1Gaf/Zrsb/oHKMr/aZdMO/GLrgmcS7Taa9slg=
Date: Thu, 20 Nov 2025 14:04:37 -0800
To: mm-commits@vger.kernel.org,slava@dubeyko.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-update-nilfs2-entry.patch removed from -mm tree
Message-Id: <20251120220438.2B67FC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: update nilfs2 entry
has been removed from the -mm tree.  Its filename was
     maintainers-update-nilfs2-entry.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: MAINTAINERS: update nilfs2 entry
Date: Sat, 8 Nov 2025 00:32:49 +0900

Viacheslav has kindly offered to help with the maintenance of nilfs2 by
upstreaming patches, similar to the HFS/HFS+ tree.  I've accepted his
offer, and will therefore add him as a co-maintainer and switch the
project's git tree for that role.

At the same time, change the outdated status field to Maintained to
reflect the current state.

Link: https://lkml.kernel.org/r/20251107153530.9023-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Acked-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/MAINTAINERS~maintainers-update-nilfs2-entry
+++ a/MAINTAINERS
@@ -18258,10 +18258,11 @@ F:	net/sunrpc/
 
 NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke@gmail.com>
+M:	Viacheslav Dubeyko <slava@dubeyko.com>
 L:	linux-nilfs@vger.kernel.org
-S:	Supported
+S:	Maintained
 W:	https://nilfs.sourceforge.io/
-T:	git https://github.com/konis/nilfs2.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vdubeyko/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
 F:	include/trace/events/nilfs2.h
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


