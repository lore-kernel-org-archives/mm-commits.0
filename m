From: akpm@linux-foundation.org
Subject: + drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value.patch added to -mm tree
Date: Tue, 23 Oct 2012 12:11:10 -0700
Message-ID: <20121023191110.9E67B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47760 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab2JWTLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 15:11:11 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so107699qae.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 12:11:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirjanov@gmail.com, borislav.petkov@amd.com, dougthompson@xmission.com


The patch titled
     Subject: drivers/edac/edac_mc_sysfs.c: check the kzalloc return value
has been added to the -mm tree.  Its filename is
     drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Denis Kirjanov <kirjanov@gmail.com>
Subject: drivers/edac/edac_mc_sysfs.c: check the kzalloc return value

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_mc_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-edac_mc_sysfsc-check-the-kzalloc-return-value
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -1136,7 +1136,8 @@ int __init edac_mc_sysfs_init(void)
 	}
 
 	mci_pdev = kzalloc(sizeof(*mci_pdev), GFP_KERNEL);
