Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19D5134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418012; cv=none; b=aBlzoZ7ic/rZuTJyYCdISi9FYEAyPC4JXxWznM5+Z7tD0XfLvkzbmARZOcPcFzTu7sj2zbsrG68a+VpbhA1GO7FnoAqAMP0NGLST5ZvbHCSZmWStjLN9m3dc691KVUd11qNowi3fQSeMwBTx31KrrAPwBd6W7ShAWRnd0pnZAw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418012; c=relaxed/simple;
	bh=dSy6SFZwHeBQxX0k9SDKsnv/fQBrlbg7fuX+d26Rfmg=;
	h=Date:To:From:Subject:Message-Id; b=R5ktMc/TnhKU7Vb8CL6j821cKTX0Bsh/5tubmszv1xHo2oFRjmESu0Vk6QYC7Ks3zkAg84U1ZMjsZOVJw5TJRqspS2EEb7UReL8EG0Kq/e1iyB0rEl4aCJSMJgqXk8/FY8SPySLR9RyoW3ExAwz/F0PrFIcWqoCzKDo3iMlcbQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fimOCAw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fimOCAw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775F4C4CEE2;
	Sat, 12 Apr 2025 00:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418012;
	bh=dSy6SFZwHeBQxX0k9SDKsnv/fQBrlbg7fuX+d26Rfmg=;
	h=Date:To:From:Subject:From;
	b=fimOCAw+vM0JPJNkbbE/1XGzyRqqpblZ28fMQXZSN/pZazZt9Tmt79zFBRMtFjMIT
	 sUNkSCCbqB7VqMEqAIVqHBvkQwAl/gNGZ5aUaIdtWohgu1e4kIcVKyaaY8g8ZqpgUj
	 ypnJq5B6YLa3Ok+SEY9uCUNmT8hMhFm1Wawl5RhU=
Date: Fri, 11 Apr 2025 17:33:31 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,masahiroy@kernel.org,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] ucs2_string-add-module-description.patch removed from -mm tree
Message-Id: <20250412003332.775F4C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucs2_string: add module description
has been removed from the -mm tree.  Its filename was
     ucs2_string-add-module-description.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: ucs2_string: add module description
Date: Mon, 24 Mar 2025 18:32:32 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in lib/ucs2_string.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-7-arnd@kernel.org
Fixes: 6c6c1fc09de3 ("modpost: require a MODULE_DESCRIPTION()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ucs2_string.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/ucs2_string.c~ucs2_string-add-module-description
+++ a/lib/ucs2_string.c
@@ -165,4 +165,5 @@ ucs2_as_utf8(u8 *dest, const ucs2_char_t
 }
 EXPORT_SYMBOL(ucs2_as_utf8);
 
+MODULE_DESCRIPTION("UCS2 string handling");
 MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from arnd@arndb.de are


