From: akpm@linux-foundation.org
Subject: + modsign-fix-a-compilation-warning-in-extract-cert.patch added
 to -mm tree
Date: Fri, 11 Sep 2015 11:26:33 -0700
Message-ID: <55f31cd9.i4JFjMzhbBJhbuls%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56047 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbIKS0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jim.epost@gmail.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MODSIGN: fix a compilation warning in extract-cert
has been added to the -mm tree.  Its filename is
     modsign-fix-a-compilation-warning-in-extract-cert.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/modsign-fix-a-compilation-warning-in-extract-cert.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/modsign-fix-a-compilation-warning-in-extract-cert.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: MODSIGN: fix a compilation warning in extract-cert

Fix the following warning when compiling extract-cert:

scripts/extract-cert.c: In function `write_cert':
scripts/extract-cert.c:89:2: warning: format not a string literal and no fo=
rmat arguments [-Wformat-security]
  ERR(!i2d_X509_bio(wb, x509), cert_dst);
  ^

whereby the ERR() macro is taking cert_dst as the format string.  "%s"
should be used as the format string as the path could contain special
characters.

Signed-off-by: David Howells <dhowells@redhat.com>
Reported-by: Jim Davis <jim.epost@gmail.com>
Acked-by : David Woodhouse <david.woodhouse@intel.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/extract-cert.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/extract-cert.c~modsign-fix-a-compilation-warning-in-extract-cert scripts/extract-cert.c
--- a/scripts/extract-cert.c~modsign-fix-a-compilation-warning-in-extract-cert
+++ a/scripts/extract-cert.c
@@ -86,7 +86,7 @@ static void write_cert(X509 *x509)
 		ERR(!wb, "%s", cert_dst);
 	}
 	X509_NAME_oneline(X509_get_subject_name(x509), buf, sizeof(buf));
-	ERR(!i2d_X509_bio(wb, x509), cert_dst);
+	ERR(!i2d_X509_bio(wb, x509), "%s", cert_dst);
 	if (kbuild_verbose)
 		fprintf(stderr, "Extracted cert: %s\n", buf);
 }
_

Patches currently in -mm which might be from dhowells@redhat.com are

modsign-fix-a-compilation-warning-in-extract-cert.patch
mutex-subsystem-synchro-test-module.patch

