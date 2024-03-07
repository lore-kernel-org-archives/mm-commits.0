Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BE5137C54
	for <mm-commits@vger.kernel.org>; Thu,  7 Mar 2024 20:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709842169; cv=none; b=MfDWq9xvVK8fkGv6jVN5FTz6sw2qnePsshyibMlwJarnFuKzzWkOSTFnf2tOYWOwCTrC5GBbldMtPMRwAqBVuB5omnKmFowHvhOpRAStfW4xCVwzfLTSdQU5ubEY9oKvV2e33fuguMkDLaPlZkXX4hT4I66ZEBOg9Vdk1QjKwzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709842169; c=relaxed/simple;
	bh=XUL+F/upuDkakL9GsX5bOpFkqpMXP9AyRUzLnUBSqeE=;
	h=Date:To:From:Subject:Message-Id; b=FlhcRizNyAF6NVk99QZZetkpiuZDOXTzUWvH8nJpFtzdAg9V3wWONL8G2c5sa5c6J3t9SG95idwYiJCrBUaDCZ+bo594y+IjGHQGJaf9tf53fUGcKRtoP8eFFtsiTmectEdwhQqqFCVPtU25wVESYVHstsi8LvO3zLbCCCv/dOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xTs91WH7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xTs91WH7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1E3C433F1;
	Thu,  7 Mar 2024 20:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709842169;
	bh=XUL+F/upuDkakL9GsX5bOpFkqpMXP9AyRUzLnUBSqeE=;
	h=Date:To:From:Subject:From;
	b=xTs91WH7K4N3HIBKNkIvMJrmdy4eyj1sMjokRAhSYo11bTrCXeVtVIbkRwm/qkxeB
	 NDqfUPeas7Z4pqDBPvhSYbN1iqxwGK8x5uCbr0DRwdy+pgSjUu5sPpofI0efZkx6qa
	 vC414AnVEGlNMOo5fU7J2pw1EbbSkv0aJux6ib/M=
Date: Thu, 07 Mar 2024 12:09:28 -0800
To: mm-commits@vger.kernel.org,s.shtylyov@omp.ru,r.smirnov@omp.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut.patch added to mm-nonmm-unstable branch
Message-Id: <20240307200928.DF1E3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: assoc_array: fix the return value in assoc_array_insert_mid_shortcut()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Roman Smirnov <r.smirnov@omp.ru>
Subject: assoc_array: fix the return value in assoc_array_insert_mid_shortcut()
Date: Thu, 7 Mar 2024 10:17:17 +0300

Returning the edit variable is redundant because it is dereferenced right
before it is returned.  It would be better to return true.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Link: https://lkml.kernel.org/r/20240307071717.5318-1-r.smirnov@omp.ru
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/assoc_array.c~assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut
+++ a/lib/assoc_array.c
@@ -938,7 +938,7 @@ static bool assoc_array_insert_mid_short
 		edit->leaf_p = &new_n0->slots[0];
 
 	pr_devel("<--%s() = ok [split shortcut]\n", __func__);
-	return edit;
+	return true;
 }
 
 /**
_

Patches currently in -mm which might be from r.smirnov@omp.ru are

assoc_array-fix-the-return-value-in-assoc_array_insert_mid_shortcut.patch

