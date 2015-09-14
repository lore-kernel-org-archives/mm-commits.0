From: akpm@linux-foundation.org
Subject: [merged] modsign-fix-a-compilation-warning-in-extract-cert.patch
 removed from -mm tree
Date: Mon, 14 Sep 2015 10:28:39 -0700
Message-ID: <55f703c7.nm4qjTSj8cqZ5P3N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbbINR2k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:28:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, jim.epost@gmail.com, jmorris@namei.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MODSIGN: fix a compilation warning in extract-cert
has been removed from the -mm tree.  Its filename was
     modsign-fix-a-compilation-warning-in-extract-cert.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mutex-subsystem-synchro-test-module.patch

