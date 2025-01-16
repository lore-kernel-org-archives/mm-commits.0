Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557917BD6
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 01:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736992334; cv=none; b=XbwTdzWU31IeCuKN7srVfI5r8I/+sZ5ruoISROEyyacnSzyNcgKUFM+K0+N9e6St8ZFkUhxtEyUe1A0duFCKMVgEMlvJrBoSybl0+9Wq6RnSkNQLhso6uNips4nCPzviwSqa1SJzGifIxj+3zcmcfDRw+MuW9/rNEuc+ASiPN3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736992334; c=relaxed/simple;
	bh=lKWvGMiYCPiBGH1oWb6qha0pXGeKYUZ1kRL5FK4TEmc=;
	h=Date:To:From:Subject:Message-Id; b=F/xZNsWF/TTyjhtIeR1RUU+/dWbdkvURBaSTxgO0awgWdljXM9bPrbGP3b2jXid/kOo9v6jSkzaEB8MwGOheCA3tpX20/Dxob1yId9KHw8vuVKrOWshQnZr76wAEFJD4nVcgN4OkReBTuys/03YtfGxW/UGjn0HVO4bGeMsdArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jbk098v0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jbk098v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01440C4CED1;
	Thu, 16 Jan 2025 01:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736992334;
	bh=lKWvGMiYCPiBGH1oWb6qha0pXGeKYUZ1kRL5FK4TEmc=;
	h=Date:To:From:Subject:From;
	b=Jbk098v0tTlAYot2xZAkNQbRganZU+qbJG+9BUYyGTEuiIl69h9KETFnsNKYqnZNu
	 6o6wBQUxqW1DOOgt9e7LwNE4LPeSjgD1hpayziq0b5vnyCgppLDTVj4D55UAS9PMhZ
	 IAY3d7jUZUKfoOseYeoxiqnQZYigpW5b2TApPQOM=
Date: Wed, 15 Jan 2025 17:52:13 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,hughd@google.com,gabriel@krisman.be,brauner@kernel.org,andrealmeid@igalia.com,karansanghvi98@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch removed from -mm tree
Message-Id: <20250116015214.01440C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: use signed int for version handling in casefold option
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


