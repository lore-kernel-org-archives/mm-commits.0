Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55571C13D
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 01:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736646176; cv=none; b=n/JXoXeVObc8Ad2KP+LvQMf1JCs12S4mo9XZ9Inpnd3l3z1g51GMphybBtSjwXJhPZHHa2u3syBfqXeS71xFVSoXusUZHYTODBN4rOFW8w9PUUj0EjasyYaFixY2V/+adiDSF9vazrMJnlaiJxqbdZyK4/mFXpREE1exUVAhW/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736646176; c=relaxed/simple;
	bh=WywD5Z/9b6cgeQX0OHna0+yDCQt9Ki4jLwz54wbJHbs=;
	h=Date:To:From:Subject:Message-Id; b=s6Xb3Qa/EgD84J1d/UBfw6LEQ8lp+Y92EEFhwUcrsB/jwLB0+LgLN/cRa6OqbBZbLah3lkBFpPQ6mhfcQ69DfIv/6FBzjmZK/uCvx9kQ8erje+72tsm/xLKwpjAGVoonUCz+CtNJuI28Dnrx9QWwQ4fGL69tTCKxlxhr79VGOno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T51/OqQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T51/OqQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADEFC4CED2;
	Sun, 12 Jan 2025 01:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736646175;
	bh=WywD5Z/9b6cgeQX0OHna0+yDCQt9Ki4jLwz54wbJHbs=;
	h=Date:To:From:Subject:From;
	b=T51/OqQRz8AH830W7WTPrSF05ZozNCn+9ctvW4VVoeHiEPHNEeiUDE8SonCLJadZg
	 DkaH9hQxAZsi7/dtgKqJK170RZivoRwOMzor+XdEFD4QLKU+YpKZUUW3NmWsHaSyzl
	 SYgSeBeQZqDGx3gjxfNSPIVPQtWNoXXZYd4nV8K0=
Date: Sat, 11 Jan 2025 17:42:55 -0800
To: mm-commits@vger.kernel.org,skhan@linuxfoundation.org,hughd@google.com,gabriel@krisman.be,brauner@kernel.org,andrealmeid@igalia.com,karansanghvi98@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch added to mm-hotfixes-unstable branch
Message-Id: <20250112014255.BADEFC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: use signed int for version handling in casefold option
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-shmem-use-signed-int-for-version-handling-in-casefold-option.patch

