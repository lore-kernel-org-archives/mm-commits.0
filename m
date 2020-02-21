From: akpm@linux-foundation.org
Subject: [patch 07/15] get_maintainer: remove uses of P: for
 maintainer name
Date: Thu, 20 Feb 2020 20:04:09 -0800
Message-ID: <20200221040409.-9SXE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbgBUEEM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 23:04:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.william@intel.com, corbet@lwn.net, joe@perches.com, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: get_maintainer: remove uses of P: for maintainer name

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
