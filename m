From: akpm@linux-foundation.org
Subject: [merged] string-on-strstrip-first-remove-leading-spaces-before-running-over-str.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:44 -0800
Message-ID: <200912152157.nBFLvitw015743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933820AbZLOV6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:58:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, mm-commits@vger.kernel.org


The patch titled
     string: on strstrip(), first remove leading spaces before running =
over str
has been removed from the -mm tree.  Its filename was
     string-on-strstrip-first-remove-leading-spaces-before-running-over=
-str.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: string: on strstrip(), first remove leading spaces before runn=
ing over str
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

=2E.. so that strlen() iterates over a smaller string comprising of the
remaining characters only.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/string.c~string-on-strstrip-first-remove-leading-spaces-b=
efore-running-over-str lib/string.c
--- a/lib/string.c~string-on-strstrip-first-remove-leading-spaces-befor=
e-running-over-str
+++ a/lib/string.c
@@ -364,8 +364,8 @@ char *strstrip(char *s)
 	size_t size;
 	char *end;
=20
+	s =3D skip_spaces(s);
 	size =3D strlen(s);
