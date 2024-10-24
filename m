Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6966E1CD3F;
	Thu, 24 Oct 2024 02:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729738373; cv=none; b=n8NO8S09Gv5K4nNNeuIUsTBzlrHVRh50UnvzfYEFBlcpOq4tPczlTFMzIuNbOxATwU0vYsyQTiDaLG9JL8FzcE4/WzSAW6JsJXMaeljtvq5WRPnzp6+YTW8nPiHWnZVRPOI2vjOxZPXF/w84GlyfEHy0xsR0FrFrDLyePp9Nros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729738373; c=relaxed/simple;
	bh=qPufH9wEOwoAVzNsymc28VGiI+tzIJ5f8Dr/m3ZspVg=;
	h=Date:To:From:Subject:Message-Id; b=LriizL6NKAS4+Gngall69/Fj/p6U4eQ/SkubGwE87pwMTjFI6Ch19vO+kSSqp95fjedz9dsftfViczgJhn1tNRJVUZM+ktOylCBxSD/THtTUs4Ak0LJk1NXQCooCbd/Y9hvSWMc0QGyPQDwkGdZHqskCkdLOymPw32Z8vSnLStc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NMcS+hBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NMcS+hBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA359C4CEC6;
	Thu, 24 Oct 2024 02:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729738372;
	bh=qPufH9wEOwoAVzNsymc28VGiI+tzIJ5f8Dr/m3ZspVg=;
	h=Date:To:From:Subject:From;
	b=NMcS+hBUN7uktt7qqhsM2wV9krRk6I8Guy1HWVYK0HhBT/jcxktRolnk6dkkphxO7
	 1a88UFkDOiFPNTN4b8iGj2O6NBzMxOXfYvoHLoIa6nM9JMr1pxemeBQIHQ5XLZ/Qru
	 CR9G7IPwGGvRvj6D/hkVH/BCzIdcjmI0VthylKI4=
Date: Wed, 23 Oct 2024 19:52:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,kees@kernel.org,James.Bottomley@HansenPartnership.com,andy@kernel.org,bartosz.golaszewski@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-string_helpers-fix-potential-snprintf-output-truncation.patch added to mm-hotfixes-unstable branch
Message-Id: <20241024025252.BA359C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: string_helpers: fix potential snprintf() output truncation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     lib-string_helpers-fix-potential-snprintf-output-truncation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-string_helpers-fix-potential-snprintf-output-truncation.patch

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
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: lib: string_helpers: fix potential snprintf() output truncation
Date: Mon, 21 Oct 2024 11:14:17 +0200

The output of ".%03u" with the unsigned int in range [0, 4294966295] may
get truncated if the target buffer is not 12 bytes.

Link: https://lkml.kernel.org/r/20241021091417.37796-1-brgl@bgdev.pl
Fixes: 3c9f3681d0b4 ("[SCSI] lib: add generic helper to print sizes rounded to the correct SI range")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/string_helpers.c~lib-string_helpers-fix-potential-snprintf-output-truncation
+++ a/lib/string_helpers.c
@@ -57,7 +57,7 @@ int string_get_size(u64 size, u64 blk_si
 	static const unsigned int rounding[] = { 500, 50, 5 };
 	int i = 0, j;
 	u32 remainder = 0, sf_cap;
-	char tmp[8];
+	char tmp[12];
 	const char *unit;
 
 	tmp[0] = '\0';
_

Patches currently in -mm which might be from bartosz.golaszewski@linaro.org are

lib-string_helpers-fix-potential-snprintf-output-truncation.patch

