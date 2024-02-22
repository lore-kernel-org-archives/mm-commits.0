Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96FBFBF4
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645185; cv=none; b=Mhdf2TW7+N3HUIfdhLwqyuVvJVbsQpUxtxFSLBKI6BGEbzLHysH/v13SCs/8k70HLDCGqpHKiivc2WvNEkh5Mo37HvcOUXxIGMyxCMgMir+MvKsgiU08Wpq7PvpeYamKcC4NsIN7M7Nl7g8DI8rU79f6tSX9bzfcfouaE8QG8mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645185; c=relaxed/simple;
	bh=y6xpaSsOyWcSuNiNhiSF7Q77+x7CKf8ebONZh7nwnew=;
	h=Date:To:From:Subject:Message-Id; b=eYzwJ/eiQMXuXuw++2bDRJwbSPF0wVy1kKOfYF2+bAw8H61Vw8VjDBBzMqIYyF+SsIfoJ3C83NAmICFwufY1bFrKBVLcMYg7Csl3LlPG21lYwBoh1SF64pUOgJG919yl37vOGMVtr1bffM75cXfUSFXSo47s99KBfnvO4vnq+0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i0shd0pJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i0shd0pJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551E5C433F1;
	Thu, 22 Feb 2024 23:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708645185;
	bh=y6xpaSsOyWcSuNiNhiSF7Q77+x7CKf8ebONZh7nwnew=;
	h=Date:To:From:Subject:From;
	b=i0shd0pJvXevSBnDZUlhiWHNe76kgsIvJvQYYEs18AquRU0OQnBLAhhuN997Pfwkr
	 UMjOsu77NTOGflA3uVkB9ZupnpJYkZajkB2s+herLPxM3iOTzEHTgJxg3QxhBC3AyH
	 +QF1S9lgntoVMj2nwsuzaL36KNXvhJ8SbHAfCXrs=
Date: Thu, 22 Feb 2024 15:39:44 -0800
To: mm-commits@vger.kernel.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-dhry-use-ktime_ms_delta-helper.patch removed from -mm tree
Message-Id: <20240222233945.551E5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: dhry: use ktime_ms_delta() helper
has been removed from the -mm tree.  Its filename was
     lib-dhry-use-ktime_ms_delta-helper.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: lib: dhry: use ktime_ms_delta() helper
Date: Mon, 22 Jan 2024 15:50:44 +0100

Use the existing ktime_ms_delta() helper instead of open-coding the same
operation.

Link: https://lkml.kernel.org/r/bb43c67a7580de6152f5e6eb225071166d33b6e4.1705934853.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dhry_1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dhry_1.c~lib-dhry-use-ktime_ms_delta-helper
+++ a/lib/dhry_1.c
@@ -277,7 +277,7 @@ int dhry(int n)
 	dhry_assert_string_eq(Str_1_Loc, "DHRYSTONE PROGRAM, 1'ST STRING");
 	dhry_assert_string_eq(Str_2_Loc, "DHRYSTONE PROGRAM, 2'ND STRING");
 
-	User_Time = ktime_to_ms(ktime_sub(End_Time, Begin_Time));
+	User_Time = ktime_ms_delta(End_Time, Begin_Time);
 
 	kfree(Ptr_Glob);
 	kfree(Next_Ptr_Glob);
_

Patches currently in -mm which might be from geert+renesas@glider.be are


