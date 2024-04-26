Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BEC7D3FE
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103976; cv=none; b=lXiMwKsifnKtIiLAKKphRDEgnCy5MyHne+oSEgMG5ANEhJtC0fMx2PBD/ilSisSEpef7OPr3KfRmwa/M0YlkzaWKq73G4Tqr8lmoHnw0R/5P/udqYKtcevADoK7psuDG6Gw8IBnRiKLE+iwFUPcn3/YzNgIDMBLk81/iQN7MSts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103976; c=relaxed/simple;
	bh=D8APo+L09Cs+/Jgs6hDeGYZBG76fFJ+Ir/7IuSDDBAg=;
	h=Date:To:From:Subject:Message-Id; b=qpThD6NQEa5szvXorX6EF8zXBOFiu3OaA9FS9kMuLkCWsP/DJDLOxeN1cS820EdB8z/e7AiCo8D6XpWM0ueALmceaG0THcPzB5DYnAiEC1To/vx3m1POxuEbMVLZwee2HqendpRa+r4nEANfib64psv3R/BYDWiiD97ry7DD6Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KpdxrdtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KpdxrdtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9CEC113CD;
	Fri, 26 Apr 2024 03:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103976;
	bh=D8APo+L09Cs+/Jgs6hDeGYZBG76fFJ+Ir/7IuSDDBAg=;
	h=Date:To:From:Subject:From;
	b=KpdxrdtJ63k7OHTNti4zFAiOaeycr/2izCh2PM8/xstwfxsuH7423RiETB4B6SFVV
	 sujCRFr71aBea1AJOYoOCpIhOkT6qxnCmiZJA68ZkrnbiYCb9tDAaR6HUS8wdbOXVC
	 HMtBOCGrLyDocAAQI5yIBDgAzeiAMM4zajH9QQTg=
Date: Thu, 25 Apr 2024 20:59:35 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-parse-vma-range-in-one-go.patch removed from -mm tree
Message-Id: <20240426035936.2B9CEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: parse VMA range in one go
has been removed from the -mm tree.  Its filename was
     selftests-mm-parse-vma-range-in-one-go.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: parse VMA range in one go
Date: Fri, 22 Mar 2024 17:35:51 +0530

Use sscanf() to directly parse the VMA range. No functional change is intended.

Link: https://lkml.kernel.org/r/20240322120551.818764-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-parse-vma-range-in-one-go
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -20,8 +20,6 @@ static int get_vm_area(unsigned long add
 	FILE *file;
 	int ret = 1;
 	char line[1024] = {0};
-	char *end_addr;
-	char *stop;
 	unsigned long start;
 	unsigned long end;
 
@@ -37,21 +35,10 @@ static int get_vm_area(unsigned long add
 	memset(area, 0, sizeof(struct vm_boundaries));
 
 	while(fgets(line, 1024, file)) {
-		end_addr = strchr(line, '-');
-		if (!end_addr) {
+		if (sscanf(line, "%lx-%lx", &start, &end) != 2) {
 			ksft_print_msg("cannot parse /proc/self/maps\n");
 			goto out;
 		}
-		*end_addr = '\0';
-		end_addr++;
-		stop = strchr(end_addr, ' ');
-		if (!stop) {
-			ksft_print_msg("cannot parse /proc/self/maps\n");
-			goto out;
-		}
-
-		sscanf(line, "%lx", &start);
-		sscanf(end_addr, "%lx", &end);
 
 		if (start <= addr && end > addr) {
 			area->start = start;
_

Patches currently in -mm which might be from dev.jain@arm.com are


