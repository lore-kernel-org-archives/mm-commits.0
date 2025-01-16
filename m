Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F1E1E505
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737004580; cv=none; b=eyL1FznI9ycmGcB7zkPv/KDR5+htTNgp3jSo4fCNr/E6A/wvqkTCd8akfa0Ezsv/G6e5BkjdMyeGurqqILT1w3AzCoMzWw1Hf+WAk7cb48aHwGRhGax1324XVkzDUacuBMa25QuxbXhCnNIE/JWFCsjWKy9pT9w+d+4bFCQsyW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737004580; c=relaxed/simple;
	bh=C13w+qRJ3XmopPe69lQMvOeW1hOnjpnO2JdSru7DJzU=;
	h=Date:To:From:Subject:Message-Id; b=ceFMJgslzF6BisBgYPsO2KUcXjhIJNxpO79IKBzGFVuMRZClHPcVy5eTYbaj0AIbmNkGvh04j5hDKwOL11H4qtjwwiV+Xee2sQysER2ONc0INoXRzbtSypPXq3bcyjj1E+mPS67te49FcyXLwawoymjN3+IdGc6VxXzmcwIdXc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p9lejyEJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p9lejyEJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727DDC4CEDD;
	Thu, 16 Jan 2025 05:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737004579;
	bh=C13w+qRJ3XmopPe69lQMvOeW1hOnjpnO2JdSru7DJzU=;
	h=Date:To:From:Subject:From;
	b=p9lejyEJfVT1UOYrdrc6bbdelYXc5BT5G0J+qulYCCuMksx1uO87fBsgito92TX6q
	 saCDl3J7cvKXCh3Cxg4JPJIXJVzPAf/d2PABBPmQ6+Bx6WybxdWs1p6h8pafGh3IZ9
	 ZNlOTcEBYZ7MnYYQHDvhLvFlT188U/iiJDVjIhxc=
Date: Wed, 15 Jan 2025 21:16:18 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,hughd@google.com,gabriel@krisman.be,brauner@kernel.org,andrealmeid@igalia.com,karansanghvi98@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch removed from -mm tree
Message-Id: <20250116051619.727DDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: use signed int for version handling in casefold option
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karan Sanghavi <karansanghvi98@gmail.com>
Subject: mm: shmem: use signed int for version handling in casefold option
Date: Sat, 11 Jan 2025 15:31:30 +0000

Fixes an issue where the use of an unsigned data type in
`shmem_parse_opt_casefold()` caused incorrect evaluation of negative
conditions.

Link: https://lkml.kernel.org/r/20250111-unsignedcompare1601569-v3-1-c861b4221831@gmail.com
Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Reviewed-by: Gabriel Krisman Bertazi <gabriel@krisman.be>
Signed-off-by: Karan Sanghavi <karansanghvi98@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickens <hughd@google.com>
Cc: Shuah khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-use-signed-int-for-version-handling-in-casefold-option
+++ a/mm/shmem.c
@@ -4368,7 +4368,7 @@ static int shmem_parse_opt_casefold(stru
 				    bool latest_version)
 {
 	struct shmem_options *ctx = fc->fs_private;
-	unsigned int version = UTF8_LATEST;
+	int version = UTF8_LATEST;
 	struct unicode_map *encoding;
 	char *version_str = param->string + 5;
 
_

Patches currently in -mm which might be from karansanghvi98@gmail.com are


