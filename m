Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A323C717
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837041; cv=none; b=ULg4X7k2wCYjmsfNa0wlSU++5fSEg1AcEDThY2U8gH1S1HzKEZPzz0imfXm5N+iuFJStwqaevR1I/IdP7LQhXl2LogTkRs8SKlK8HVsdgJvSl7BWHM6Ufq+H24plv33cRa3A1l651tf6OlwVR2eZ6io0rDLNlZPEgiHn+Q1Gd1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837041; c=relaxed/simple;
	bh=KtN6rkNMIEbY9N+kuVlblbUbdO6CaLkfqm84Sptvoto=;
	h=Date:To:From:Subject:Message-Id; b=J6aoKtg6fEL3wgT8wN94YGdApB9sZ5hPfQBdqXWrNnSQhM9JgPCPwVUFJVSQxACwtryh5MuSURc+9jojOkw3Eg6Ie9pB8Xthlp6Bldy9caZU8CYFOhxY0WWKA65AcYeuFiDm5yPkwH8M3PQOTBb5V4yesIxLNGEoFqcb2J6ssNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2eVQm2/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2eVQm2/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619B2C4CEDD;
	Tue, 14 Jan 2025 06:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837041;
	bh=KtN6rkNMIEbY9N+kuVlblbUbdO6CaLkfqm84Sptvoto=;
	h=Date:To:From:Subject:From;
	b=2eVQm2/irv9hv+04X3ezxXrB9nWv11SGFeOQEjcw5MauIprnaEtC/AHPtv/LITd0N
	 UHLUndpsUBZKMGOTVvX8a0ym6JyCJnAa/UX48GTf7YSQcmcRTcfJFq0QrtD79tL86F
	 EbrDOIAsOhWLrvWHTLzm16cMjczfCI/Tvjw3dHXY=
Date: Mon, 13 Jan 2025 22:44:00 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,ryan.roberts@arm.com,keith.lucas@oracle.com,joey.gouly@arm.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aruna.ramakrishna@oracle.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-strncpy-length.patch removed from -mm tree
Message-Id: <20250114064401.619B2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix strncpy() length
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-strncpy-length.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: selftests/mm: fix strncpy() length
Date: Mon, 9 Dec 2024 09:50:08 +0000

GCC complains (with -O2) that the length is equal to the destination size,
which is indeed invalid.  Subtract 1 from the size of the array to leave
room for '\0'.

Link: https://lkml.kernel.org/r/20241209095019.1732120-4-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Keith Lucas <keith.lucas@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/write_to_hugetlbfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c~selftests-mm-fix-strncpy-length
+++ a/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -89,7 +89,7 @@ int main(int argc, char **argv)
 			size = atoi(optarg);
 			break;
 		case 'p':
-			strncpy(path, optarg, sizeof(path));
+			strncpy(path, optarg, sizeof(path) - 1);
 			break;
 		case 'm':
 			if (atoi(optarg) >= MAX_METHOD) {
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


