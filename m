From: akpm@linux-foundation.org
Subject: + scripts-kernel-doc-dont-eat-struct-members-with-__aligned.patch added to -mm tree
Date: Wed, 19 Nov 2014 12:58:37 -0800
Message-ID: <546d047d.GjHs0U2AbZsLufGO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaKSU6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Nov 2014 15:58:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes.berg@intel.com, mmarek@suse.cz, nm@ti.com, rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/kernel-doc: don't eat struct members with __aligned
has been added to the -mm tree.  Its filename is
     scripts-kernel-doc-dont-eat-struct-members-with-__aligned.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-kernel-doc-dont-eat-struct-members-with-__aligned.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/scripts-kernel-doc-dont-eat-struct-members-with-__aligned.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: scripts/kernel-doc: don't eat struct members with __aligned

The change from \d+ to .+ inside __aligned() means that the following
structure:
struct test {
	u8 a __aligned(2);
	u8 b __aligned(2);
};

essentially gets modified to

struct test {
	u8 a;
};

for purposes of kernel-doc, thus dropping a struct member, which in turns
causes warnings and invalid kernel-doc generation.

Fix this by replacing the catch-all (".") with anything that's not a
semicolon ("[^;]").

Fixes: 9dc30918b23f ("scripts/kernel-doc: handle struct member __aligned without numbers")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kernel-doc~scripts-kernel-doc-dont-eat-struct-members-with-__aligned scripts/kernel-doc
--- a/scripts/kernel-doc~scripts-kernel-doc-dont-eat-struct-members-with-__aligned
+++ a/scripts/kernel-doc
@@ -1753,7 +1753,7 @@ sub dump_struct($$) {
 	# strip kmemcheck_bitfield_{begin,end}.*;
 	$members =~ s/kmemcheck_bitfield_.*?;//gos;
 	# strip attributes
-	$members =~ s/__aligned\s*\(.+\)//gos;
+	$members =~ s/__aligned\s*\([^;]*\)//gos;
 
 	create_parameterlist($members, ';', $file);
 	check_sections($file, $declaration_name, "struct", $sectcheck, $struct_actual, $nested);
_

Patches currently in -mm which might be from johannes.berg@intel.com are

scripts-kernel-doc-dont-eat-struct-members-with-__aligned.patch
linux-next.patch

