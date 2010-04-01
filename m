From: akpm@linux-foundation.org
Subject: + cifs-provide-user-with-a-hint-when-name-resolution-fails.patch added to -mm tree
Date: Thu, 01 Apr 2010 11:58:49 -0700
Message-ID: <201004011858.o31IwneL003025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044Ab0DAS7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 14:59:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: timo.witte@googlemail.com, sfrench@samba.org


The patch titled
     cifs: provide user with a hint when name resolution fails
has been added to the -mm tree.  Its filename is
     cifs-provide-user-with-a-hint-when-name-resolution-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: provide user with a hint when name resolution fails
From: Timo Witte <timo.witte@googlemail.com>

Add additional info to the error message.  cifs tries to resolve DNS Names
via /sbin/request-key but this is not installed by default in Ubuntu
systems, so you cant use DFS shares correctly without it.

Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/dns_resolve.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/cifs/dns_resolve.c~cifs-provide-user-with-a-hint-when-name-resolution-fails fs/cifs/dns_resolve.c
--- a/fs/cifs/dns_resolve.c~cifs-provide-user-with-a-hint-when-name-resolution-fails
+++ a/fs/cifs/dns_resolve.c
@@ -138,7 +138,8 @@ dns_resolve_server_name_to_ip(const char
 		len = rkey->type_data.x[0];
 		data = rkey->payload.data;
 	} else {
-		cERROR(1, ("%s: unable to resolve: %s", __func__, name));
+		cERROR(1, ("%s: unable to resolve: %s have you "
+			"installed /sbin/request-key ?", __func__, name));
 		goto out;
 	}
 
_

Patches currently in -mm which might be from timo.witte@googlemail.com are

cifs-provide-user-with-a-hint-when-name-resolution-fails.patch

