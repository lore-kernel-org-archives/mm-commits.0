From: akpm@linux-foundation.org
Subject: + lib-cmdlinec-declare-exported-symbols-immediately.patch added
 to -mm tree
Date: Mon, 18 Nov 2013 15:48:55 -0800
Message-ID: <528aa767.8odNICn1nkQlEc5V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3KRXs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 18:48:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, levex@linux.com, felipe.contreras@gmail.com

Subject: + lib-cmdlinec-declare-exported-symbols-immediately.patch added to -mm tree
To: felipe.contreras@gmail.com,levex@linux.com
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 15:48:55 -0800


The patch titled
     Subject: lib/cmdline.c: declare exported symbols immediately
has been added to the -mm tree.  Its filename is
     lib-cmdlinec-declare-exported-symbols-immediately.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-cmdlinec-declare-exported-symbols-immediately.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-cmdlinec-declare-exported-symbols-immediately.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: lib/cmdline.c: declare exported symbols immediately

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(memparse);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(get_option);

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
+EXPORT_SYMBOL(get_options);

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Levente Kurusa <levex@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/cmdline.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN lib/cmdline.c~lib-cmdlinec-declare-exported-symbols-immediately lib/cmdline.c
--- a/lib/cmdline.c~lib-cmdlinec-declare-exported-symbols-immediately
+++ a/lib/cmdline.c
@@ -67,6 +67,7 @@ int get_option(char **str, int *pint)
 
 	return 1;
 }
+EXPORT_SYMBOL(get_option);
 
 /**
  *	get_options - Parse a string into a list of integers
@@ -112,6 +113,7 @@ char *get_options(const char *str, int n
 	ints[0] = i - 1;
 	return (char *)str;
 }
+EXPORT_SYMBOL(get_options);
 
 /**
  *	memparse - parse a string with mem suffixes into a number
@@ -152,7 +154,4 @@ unsigned long long memparse(const char *
 
 	return ret;
 }
