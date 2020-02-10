From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 get_maintainer-remove-uses-of-p-for-maintainer-name.patch added to -mm tree
Date: Sun, 09 Feb 2020 20:29:49 -0800
Message-ID: <20200210042949.iKYjF6LK8%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgBJE3w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Feb 2020 23:29:52 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, dan.j.william@intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: Remove uses of P: for maintainer name
has been added to the -mm tree.  Its filename is
     get_maintainer-remove-uses-of-p-for-maintainer-name.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-remove-uses-of-p-for-maintainer-name.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-remove-uses-of-p-for-maintainer-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: get_maintainer: Remove uses of P: for maintainer name

commit 1ca84ed6425f ("MAINTAINERS: Reclaim the P: tag for Maintainer Entry
Profile") changed the use of the "P:" tag from "Person" to "Profile (ie:
special subsystem coding styles and characteristics)"

Change how get_maintainer.pl parses the "P:" tag to match.

Link: http://lkml.kernel.org/r/ca53823fc5d25c0be32ad937d0207a0589c08643.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Dan Williams <dan.j.william@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-remove-uses-of-p-for-maintainer-name
+++ a/scripts/get_maintainer.pl
@@ -1341,35 +1341,11 @@ sub add_categories {
 		    }
 		}
 	    } elsif ($ptype eq "M") {
-		my ($name, $address) = parse_email($pvalue);
-		if ($name eq "") {
-		    if ($i > 0) {
-			my $tv = $typevalue[$i - 1];
-			if ($tv =~ m/^([A-Z]):\s*(.*)/) {
-			    if ($1 eq "P") {
-				$name = $2;
-				$pvalue = format_email($name, $address, $email_usename);
-			    }
-			}
-		    }
-		}
 		if ($email_maintainer) {
 		    my $role = get_maintainer_role($i);
 		    push_email_addresses($pvalue, $role);
 		}
 	    } elsif ($ptype eq "R") {
-		my ($name, $address) = parse_email($pvalue);
-		if ($name eq "") {
-		    if ($i > 0) {
-			my $tv = $typevalue[$i - 1];
-			if ($tv =~ m/^([A-Z]):\s*(.*)/) {
-			    if ($1 eq "P") {
-				$name = $2;
-				$pvalue = format_email($name, $address, $email_usename);
-			    }
-			}
-		    }
-		}
 		if ($email_reviewer) {
 		    my $subsystem = get_subsystem_name($i);
 		    push_email_addresses($pvalue, "reviewer:$subsystem");
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-remove-uses-of-p-for-maintainer-name.patch
string-add-stracpy-and-stracpy_pad-mechanisms.patch
