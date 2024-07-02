Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9D8372
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 07:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719904334; cv=none; b=j6Cs0BlgrGXrpKmD9PuDSJJ/MKZ5a47IKdsygOYe+E4NYBPjWw49DNvUpfMr2C8xUbkiDLmLr9Yn90khZ1x6P5P/g6hdpQMNffxXAPoObsRwiYq1PpwMieryIyZvVEFJvP0zihLdlzxg/e6BuveanpB3J/rkMOvyS+0pTANSQk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719904334; c=relaxed/simple;
	bh=auIMJcCOYgyJzydrx5zODdYyowQ/gbHmqkmcyn3/zYc=;
	h=Date:To:From:Subject:Message-Id; b=Vdmd5hmgBVJhq/7/6wcrsFXt3y89dOgWYB0823OIK5X4w6oP7n+JzWLxC7dgbnl1FLeuHxLUN7CaFioDNNCwBVoyydKKdnWomAWMPFzH5TLJGjVJttEKIsZEoSOMv18eXy21ZW0cnae4nrrmcwG21g2037/T8RNEd+RPkSc5FGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eTqiwWt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eTqiwWt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73E9C116B1;
	Tue,  2 Jul 2024 07:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719904333;
	bh=auIMJcCOYgyJzydrx5zODdYyowQ/gbHmqkmcyn3/zYc=;
	h=Date:To:From:Subject:From;
	b=eTqiwWt3kfHfvbHdKsVI3okMwDlJ5aWlq/TwUpj6wrSUmYjM6sF0lg3+TfACT4jqy
	 haJ61Nv6leI8Mi+Qdy03FQ+xNFi93/vhhbgZRoY2xE8xTOlCAiQpgtBYMnFGPWf03v
	 zNh3MhIoGq+srGZZx16tZ6g0ukx8vunTwoEA2JuE=
Date: Tue, 02 Jul 2024 00:12:13 -0700
To: mm-commits@vger.kernel.org,dushistov@mail.ru,brauner@kernel.org,quic_jjohnson@quicinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-ufs-add-module_description.patch added to mm-nonmm-unstable branch
Message-Id: <20240702071213.A73E9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs: ufs: add MODULE_DESCRIPTION()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-ufs-add-module_description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-ufs-add-module_description.patch

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
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: fs: ufs: add MODULE_DESCRIPTION()
Date: Fri, 10 May 2024 12:02:15 -0700

Fix make W=1 warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in fs/ufs/ufs.o

Link: https://lkml.kernel.org/r/20240510-ufs-md-v1-1-85eaff8c6beb@quicinc.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ufs/super.c~fs-ufs-add-module_description
+++ a/fs/ufs/super.c
@@ -1540,4 +1540,5 @@ static void __exit exit_ufs_fs(void)
 
 module_init(init_ufs_fs)
 module_exit(exit_ufs_fs)
+MODULE_DESCRIPTION("UFS Filesystem");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from quic_jjohnson@quicinc.com are

fs-ufs-add-module_description.patch

