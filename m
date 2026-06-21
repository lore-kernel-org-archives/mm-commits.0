Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F42370ACD
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067211; cv=none; b=dSbNIvXHNoGTWL9s1Iq4meTJUmnJp7waAVKSi4cFmx62pw4JbRuFDAiAZxHVnIE/Q63dtNhrkqpJs3YWuWs7TvR6VURtjaPI4rl1AnSF1LGhexIXt8ESSFkomnZr5FPGDnXNu4c55O7lbWUHo39gG2DkAqFgqbgl/Dm+AXpERXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067211; c=relaxed/simple;
	bh=YHBtYXIHrupXE7A0yCzKPXzvaMJKYTUti1DhiSOMLMk=;
	h=Date:To:From:Subject:Message-Id; b=S4BFHs/OKUKNhGkAtnpR0YXvD8qN1pbWxZgQYW5dhBBvPbNacF90nOqeoGx9ANe49cpTheF/9VhaVvF+d+ASBPfpfwECC4VKf+YoHupdL3Fj4fAdaPrcY0x4z7syWKuA77oXV0vh59agvUt7tTLUro5o98/ffEvgB1V4M5zXuJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJjVr59J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJjVr59J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB2A1F000E9;
	Sun, 21 Jun 2026 18:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067209;
	bh=rbfSSGO/4nE2nFE8lphFR0JoLtdzaYTsSfLqnFjqV0s=;
	h=Date:To:From:Subject;
	b=DJjVr59JJBY7ADDVFmtuXtdArTh4sSXoI8KYx+gW/1MQBYFXC/a4BjfJpbD47t05K
	 rRTVzefel4YICNiTK54tq+4+2z7FcMNFbchmYtRONg8lhUHiVIKFOsgGFxYaHE/A7t
	 e6nqzNbXWsWPlZeDa/aAbcbXFocZ1sLO5kEsF0n4=
Date: Sun, 21 Jun 2026 11:40:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,venkat88@linux.ibm.com,shuah@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,mhocko@kernel.org,linmiaohe@huawei.com,liam.howlett@oracle.com,dev.jain@arm.com,david@kernel.org,sayalip@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch removed from -mm tree
Message-Id: <20260621184009.CEB2A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: clarify alternate unmapping in compaction_test
has been removed from the -mm tree.  Its filename was
     selftests-mm-clarify-alternate-unmapping-in-compaction_test.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sayali Patil <sayalip@linux.ibm.com>
Subject: selftests/mm: clarify alternate unmapping in compaction_test
Date: Thu, 21 May 2026 12:17:53 +0530

Add a comment explaining that every other entry in the list is unmapped to
intentionally create fragmentation with locked pages before invoking
check_compaction().

Link: https://lore.kernel.org/da5e0a8d5152e54152c0d2f456aac2fac35af291.1779296493.git.sayalip@linux.ibm.com
Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/compaction_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/mm/compaction_test.c~selftests-mm-clarify-alternate-unmapping-in-compaction_test
+++ a/tools/testing/selftests/mm/compaction_test.c
@@ -181,6 +181,9 @@ int main(int argc, char **argv)
 		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
+	/* Unmap every other entry in the list to create fragmentation with
+	 * locked pages before invoking check_compaction().
+	 */
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
 		if (!entry->next)
_

Patches currently in -mm which might be from sayalip@linux.ibm.com are


