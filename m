Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59E67493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YnoAK0Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C0FC433C8;
	Mon, 11 Dec 2023 01:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257809;
	bh=0UaHTcMagufoEabD/4OQFDWfKJ7bUJXRN3I1UIXybvk=;
	h=Date:To:From:Subject:From;
	b=YnoAK0ZiLOxh/hXDeUiaEckd+egQORcntBbxl6X/dyG9WRp+EiUCy9Bkh1H63kqma
	 2iu5nQ8s+SySj5wFhwSg0FMdtJxIX22Zag8rZWYC6zmdhMpeorfS+OhzJ3ewp1+Xy2
	 eOGUQLdOwqT6PCYnG4i6cypZjkbiZObaAKIs8cOI=
Date: Sun, 10 Dec 2023 17:23:29 -0800
To: mm-commits@vger.kernel.org,svens@linux.ibm.com,sth@linux.ibm.com,hoeppner@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,borntraeger@linux.ibm.com,arnd@arndb.de,agordeev@linux.ibm.com,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] s390-dasd-remove-dasd_stats_generic_show.patch removed from -mm tree
Message-Id: <20231211012329.70C0FC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/dasd: remove dasd_stats_generic_show()
has been removed from the -mm tree.  Its filename was
     s390-dasd-remove-dasd_stats_generic_show.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: s390/dasd: remove dasd_stats_generic_show()
Date: Thu, 30 Nov 2023 17:22:32 -0700

Patch series "s390: A couple of fixes for -Wmissing-prototypes".

This series resolves a couple of -Wmissing-prototypes that I see in my
builds of -next, even though the issues appear to be latent.  This
addresses issues which will be exposed by the later patch
"Makefile.extrawarn: turn on missing-prototypes globally".


This patch (of 2):

With CONFIG_DASD_PROFILE=n, there is a warning that
dasd_stats_generic_show() is missing a prototype:

  drivers/s390/block/dasd.c:1109:5: warning: no previous prototype for 'dasd_stats_generic_show' [-Wmissing-prototypes]
   1109 | int dasd_stats_generic_show(struct seq_file *m, void *v)
        |     ^~~~~~~~~~~~~~~~~~~~~~~

This function has been unused since its introduction in commit
4fa52aa7a82f ("[S390] dasd: add enhanced DASD statistics interface"),
remove it to clear up the warning.

Link: https://lkml.kernel.org/r/20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org
Link: https://lkml.kernel.org/r/20231130-s390-missing-prototypes-v1-1-799d3cf07fb7@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Höppner <hoeppner@linux.ibm.com>
Cc: Stefan Haberland <sth@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dasd.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/s390/block/dasd.c~s390-dasd-remove-dasd_stats_generic_show
+++ a/drivers/s390/block/dasd.c
@@ -1106,12 +1106,6 @@ static void dasd_statistics_removeroot(v
 	return;
 }
 
-int dasd_stats_generic_show(struct seq_file *m, void *v)
-{
-	seq_puts(m, "Statistics are not activated in this kernel\n");
-	return 0;
-}
-
 static void dasd_profile_init(struct dasd_profile *profile,
 			      struct dentry *base_dentry)
 {
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

