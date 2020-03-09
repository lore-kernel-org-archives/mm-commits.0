From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 checkpatch-check-proper-licensing-of-devicetree-bindings.patch added to -mm
 tree
Date: Mon, 09 Mar 2020 16:34:11 -0700
Message-ID: <20200309233411.kqYJKgYKj%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgCIXeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 19:34:13 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, daniel@ffwll.ch, jernej.skrabec@siol.net, joe@perches.com, jonas@kwiboo.se, Laurent.pinchart@ideasonboard.com, lkundrak@v3.sk, mark.rutland@arm.com, mm-commits@vger.kernel.org, narmstrong@baylibre.com, robh@kernel.org


The patch titled
     Subject: checkpatch: check proper licensing of Devicetree bindings
has been added to the -mm tree.  Its filename is
     checkpatch-check-proper-licensing-of-devicetree-bindings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-check-proper-licensing-of-devicetree-bindings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-check-proper-licensing-of-devicetree-bindings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3171,6 +3171,17 @@ sub process {
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

checkpatch-check-spdx-tags-in-yaml-files.patch
checkpatch-check-proper-licensing-of-devicetree-bindings.patch
