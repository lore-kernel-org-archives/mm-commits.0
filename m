From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 135/166] checkpatch: check proper licensing of
 Devicetree bindings
Date: Mon, 06 Apr 2020 20:11:13 -0700
Message-ID: <20200407031113.32cyhpO2F%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbgDGDLP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:11:15 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: airlied@linux.ie, akpm@linux-foundation.org, daniel@ffwll.ch, jernej.skrabec@siol.net, joe@perches.com, jonas@kwiboo.se, Laurent.pinchart@ideasonboard.com, linux-mm@kvack.org, lkundrak@v3.sk, mark.rutland@arm.com, mm-commits@vger.kernel.org, narmstrong@baylibre.com, robh@kernel.org, torvalds@linux-foundation.org

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
