From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-check-proper-licensing-of-devicetree-bindings.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 19:01:43 -0700
Message-ID: <20200408020143.rdvXxL8V4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCBo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, daniel@ffwll.ch, jernej.skrabec@siol.net, joe@perches.com, jonas@kwiboo.se, laurent.pinchart@ideasonboard.com, lkundrak@v3.sk, mark.rutland@arm.com, mm-commits@vger.kernel.org, narmstrong@baylibre.com, robh@kernel.org


The patch titled
     Subject: checkpatch: check proper licensing of Devicetree bindings
has been removed from the -mm tree.  Its filename was
     checkpatch-check-proper-licensing-of-devicetree-bindings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lubomir Rintel <lkundrak@v3.sk>
Subject: checkpatch: check proper licensing of Devicetree bindings

According to Devicetree maintainers (see Link: below), the Devicetree
binding documents are preferrably licensed (GPL-2.0-only OR BSD-2-Clause).

Let's check that.  The actual check is a bit more relaxed, to allow more
liberal but compatible licensing (e.g.  GPL-2.0-or-later OR BSD-2-Clause).

Link: https://lore.kernel.org/lkml/20200108142132.GA4830@bogus/
Link: http://lkml.kernel.org/r/20200309215153.38824-1-lkundrak@v3.sk
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Acked-by: Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
Cc: Jonas Karlman <jonas@kwiboo.se>,
Cc: Jernej Skrabec <jernej.skrabec@siol.net>,
Cc: Mark Rutland <mark.rutland@arm.com>,
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>,
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-check-proper-licensing-of-devicetree-bindings
+++ a/scripts/checkpatch.pl
@@ -3157,6 +3157,17 @@ sub process {
 						WARN("SPDX_LICENSE_TAG",
 						     "'$spdx_license' is not supported in LICENSES/...\n" . $herecurr);
 					}
+					if ($realfile =~ m@^Documentation/devicetree/bindings/@ &&
+					    not $spdx_license =~ /GPL-2\.0.*BSD-2-Clause/) {
+						my $msg_level = \&WARN;
+						$msg_level = \&CHK if ($file);
+						if (&{$msg_level}("SPDX_LICENSE_TAG",
+
+								  "DT binding documents should be licensed (GPL-2.0-only OR BSD-2-Clause)\n" . $herecurr) &&
+						    $fix) {
+							$fixed[$fixlinenr] =~ s/SPDX-License-Identifier: .*/SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)/;
+						}
+					}
 				}
 			}
 		}
_

Patches currently in -mm which might be from lkundrak@v3.sk are
