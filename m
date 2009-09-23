From: akpm@linux-foundation.org
Subject: [merged] markup_oops-use-modinfo-to-avoid-confusion-with-underscored-module-names.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:32 -0700
Message-ID: <200909232004.n8NK4Wkn021450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbZIWUFa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ozan@pardus.org.tr, arjan@infradead.org, sam@ravnborg.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     markup_oops: use modinfo to avoid confusion with underscored modul=
e names
has been removed from the -mm tree.  Its filename was
     markup_oops-use-modinfo-to-avoid-confusion-with-underscored-module=
-names.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: markup_oops: use modinfo to avoid confusion with underscored m=
odule names
=46rom: Ozan =C7aglayan <ozan@pardus.org.tr>

When EIP is at a module having an underscore in its name, the current c=
ode
fails to find it because the module filenames has '-' instead of '_'.  =
Use
modinfo for a better path finding.

Signed-off-by: Ozan =C7aglayan <ozan@pardus.org.tr>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/markup_oops.pl |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN scripts/markup_oops.pl~markup_oops-use-modinfo-to-avoid-confu=
sion-with-underscored-module-names scripts/markup_oops.pl
--- a/scripts/markup_oops.pl~markup_oops-use-modinfo-to-avoid-confusion=
-with-underscored-module-names
+++ a/scripts/markup_oops.pl
@@ -184,10 +184,7 @@ if ($target eq "0") {
=20
 # if it's a module, we need to find the .ko file and calculate a load =
offset
 if ($module ne "") {
-	my $dir =3D dirname($filename);
-	$dir =3D $dir . "/";
-	my $mod =3D $module . ".ko";
-	my $modulefile =3D `find $dir -name $mod | head -1`;
+	my $modulefile =3D `modinfo $module | grep '^filename:' | awk '{ prin=
t \$2 }'`;
 	chomp($modulefile);
 	$filename =3D $modulefile;
 	if ($filename eq "") {
_

Patches currently in -mm which might be from ozan@pardus.org.tr are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
