Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EBA8F5B
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727894442; cv=none; b=t4+1OwvYaFluw3ICGe3oAKGQtnHpkmQJqmUr+989uENlb+QKsDA5Sd6vsQvA2Y5aJVZZSa4a+Z/h4ogqVmLiZJqCKjSSimTgSDnhS3fqNGTQY0NMs928gzFEXOFBakDbYllH/laUgVy1KfEdftEMpT9kiuUZCorgdUPioJW5ZG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727894442; c=relaxed/simple;
	bh=PQauVBU3qZgWWKJrjxHTUmjf25epbI6AD/NCDh4r12s=;
	h=Date:To:From:Subject:Message-Id; b=PUQTXVFzXIZ2lmTVbkQ6BY43MazZf2+8T/uLGMZxQIHXU05M+APUO/w1jIBiEZCE9TNYAOobprZD/tK2ajX9RbAvgWcNhoyXVVoZZfmmTEbIH7Juwo0FyEPvNKKTzCcz+XvlcAbydfVfXkPNNMTZAyuvAwk3NIkehivlNEFDmFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LdfRcC1r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LdfRcC1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8648C4CEC2;
	Wed,  2 Oct 2024 18:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727894442;
	bh=PQauVBU3qZgWWKJrjxHTUmjf25epbI6AD/NCDh4r12s=;
	h=Date:To:From:Subject:From;
	b=LdfRcC1rkUTUSLihxWJfoPS6ii8BJNS+a/lI8i82gmhdRuMCvP113E01ONlYYVtII
	 cV4JM61eUtKeBJ/OyX4qxhqeZSqtAXimbXFDbFvo39QlmROmy06XMO/LYDhF4dHqg/
	 rTtXpBV0ZiocRCfgGU1YaOSRdAsDfOXRx+/EfNHo=
Date: Wed, 02 Oct 2024 11:40:41 -0700
To: mm-commits@vger.kernel.org,arnd@arndb.de,krzysztof.kozlowski@linaro.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + credits-sort-alphabetically-by-name.patch added to mm-hotfixes-unstable branch
Message-Id: <20241002184041.E8648C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: CREDITS: sort alphabetically by name
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     credits-sort-alphabetically-by-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/credits-sort-alphabetically-by-name.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: CREDITS: sort alphabetically by name
Date: Wed, 2 Oct 2024 13:19:32 +0200

Re-sort few misplaced entries in the CREDITS file.

Link: https://lkml.kernel.org/r/20241002111932.46012-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS |   54 +++++++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/CREDITS~credits-sort-alphabetically-by-name
+++ a/CREDITS
@@ -1358,10 +1358,6 @@ D: Major kbuild rework during the 2.5 cy
 D: ISDN Maintainer
 S: USA
 
-N: Gerrit Renker
-E: gerrit@erg.abdn.ac.uk
-D: DCCP protocol support.
-
 N: Philip Gladstone
 E: philip@gladstonefamily.net
 D: Kernel / timekeeping stuff
@@ -1677,11 +1673,6 @@ W: http://www.carumba.com/
 D: bug toaster (A1 sauce makes all the difference)
 D: Random linux hacker
 
-N: James Hogan
-E: jhogan@kernel.org
-D: Metag architecture maintainer
-D: TZ1090 SoC maintainer
-
 N: Tim Hockin
 E: thockin@hockin.org
 W: http://www.hockin.org/~thockin
@@ -1697,6 +1688,11 @@ D: hwmon subsystem maintainer
 D: i2c-sis96x and i2c-stub SMBus drivers
 S: USA
 
+N: James Hogan
+E: jhogan@kernel.org
+D: Metag architecture maintainer
+D: TZ1090 SoC maintainer
+
 N: Dirk Hohndel
 E: hohndel@suse.de
 D: The XFree86[tm] Project
@@ -1872,6 +1868,10 @@ S: K osmidomkum 723
 S: 160 00 Praha 6
 S: Czech Republic
 
+N: Seth Jennings
+E: sjenning@redhat.com
+D: Creation and maintenance of zswap
+
 N: Jeremy Kerr
 D: Maintainer of SPU File System
 
@@ -2188,19 +2188,6 @@ N: Mike Kravetz
 E: mike.kravetz@oracle.com
 D: Maintenance and development of the hugetlb subsystem
 
-N: Seth Jennings
-E: sjenning@redhat.com
-D: Creation and maintenance of zswap
-
-N: Dan Streetman
-E: ddstreet@ieee.org
-D: Maintenance and development of zswap
-D: Creation and maintenance of the zpool API
-
-N: Vitaly Wool
-E: vitaly.wool@konsulko.com
-D: Maintenance and development of zswap
-
 N: Andreas S. Krebs
 E: akrebs@altavista.net
 D: CYPRESS CY82C693 chipset IDE, Digital's PC-Alpha 164SX boards
@@ -3191,6 +3178,11 @@ N: Ken Pizzini
 E: ken@halcyon.com
 D: CDROM driver "sonycd535" (Sony CDU-535/531)
 
+N: Mathieu Poirier
+E: mathieu.poirier@linaro.org
+D: CoreSight kernel subsystem, Maintainer 2014-2022
+D: Perf tool support for CoreSight
+
 N: Stelian Pop
 E: stelian@popies.net
 P: 1024D/EDBB6147 7B36 0E07 04BC 11DC A7A0  D3F7 7185 9E7A EDBB 6147
@@ -3300,6 +3292,10 @@ S: Schlossbergring 9
 S: 79098 Freiburg
 S: Germany
 
+N: Gerrit Renker
+E: gerrit@erg.abdn.ac.uk
+D: DCCP protocol support.
+
 N: Thomas Renninger
 E: trenn@suse.de
 D: cpupowerutils
@@ -3576,11 +3572,6 @@ D: several improvements to system progra
 S: Oldenburg
 S: Germany
 
-N: Mathieu Poirier
-E: mathieu.poirier@linaro.org
-D: CoreSight kernel subsystem, Maintainer 2014-2022
-D: Perf tool support for CoreSight
-
 N: Robert Schwebel
 E: robert@schwebel.de
 W: https://www.schwebel.de
@@ -3771,6 +3762,11 @@ S: Chr. Winthersvej 1 B, st.th.
 S: DK-1860 Frederiksberg C
 S: Denmark
 
+N: Dan Streetman
+E: ddstreet@ieee.org
+D: Maintenance and development of zswap
+D: Creation and maintenance of the zpool API
+
 N: Drew Sullivan
 E: drew@ss.org
 W: http://www.ss.org/
@@ -4286,6 +4282,10 @@ S: Pipers Way
 S: Swindon. SN3 1RJ
 S: England
 
+N: Vitaly Wool
+E: vitaly.wool@konsulko.com
+D: Maintenance and development of zswap
+
 N: Chris Wright
 E: chrisw@sous-sol.org
 D: hacking on LSM framework and security modules.
_

Patches currently in -mm which might be from krzysztof.kozlowski@linaro.org are

credits-sort-alphabetically-by-name.patch

