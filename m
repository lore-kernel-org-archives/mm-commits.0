Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DFF73FBB5E
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660966; cv=none; b=MMNAZMgn1vHpZQqrGdz6roXCouj0d2CjOEkKYCEv2ciy2duQo44OyGzIuiyO0lyilEuxQVtRFQi+iRwPjhObm/yqL8nyuy7YB4nXtiJ3g0Zy01q3FAVlvhndaEvBfKYcj4HoGXrrtzoKYp5rB9fs84b6S4F0fUUSvTEKHdg51Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660966; c=relaxed/simple;
	bh=hO/zmzF1U78VxGW/mMIjYT1MQLujjz+AXk059rQL+CI=;
	h=Date:To:From:Subject:Message-Id; b=Uu8uiOyMbpc250kxmJ2Ph4gl8G3mzlP2dft4EsEL2/lj+HV/6y6si8+9KZih3D2xISiQe4qk8uLFdCE8n5MBb8QYa/YJdqIkuNSR29U/8GMr5JXyHUp3na1KU8Pc+AEoPdn3t889WaoVGQ25ARFXuko59WUH7XT7bYn2IqzFYkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sm1AaGFy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sm1AaGFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FEB1F00A3A;
	Thu, 13 Aug 2026 22:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660965;
	bh=uP83sv10P6jzmgSkwyDK97+BD9Ea2P8tb68zJUB5W50=;
	h=Date:To:From:Subject;
	b=Sm1AaGFyA8pxaH9e2UE7lj0xullmgQvZMhJC1UysLA4zbR6obn6P3OY8ShhyR0zRp
	 8rk5EXp/gYwEJ7x8NfWouyU79AeJZ+JzcmqgKMD+GQZyuaX2OAzewC1OC2m1f2Ry08
	 Hzavu5qcK6eIn/rv9BnEhkvJ88veF4rqHKTDPRrk=
Date: Thu, 13 Aug 2026 15:42:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhen.ni@easystack.cn,ye.liu@linux.dev,vishal.moola@gmail.com,akpm@linux-foundation.org,warren.xiong@ugreen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-mm-prevent-page_owner_sort-from-truncating-input.patch removed from -mm tree
Message-Id: <20260813224245.33FEB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: prevent page_owner_sort from truncating input
has been removed from the -mm tree.  Its filename was
     tools-mm-prevent-page_owner_sort-from-truncating-input.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Warren Xiong <warren.xiong@ugreen.com>
Subject: tools/mm: prevent page_owner_sort from truncating input
Date: Thu, 30 Jul 2026 09:58:09 +0800

page_owner_sort opens the output file with "w" before reading the input. 
If both paths refer to the same file, this truncates the input and the
tool silently processes zero records before returning success.

Delay opening the output file until all input records have been loaded
into memory.  This allows the tool to sort a file in place without
truncating data before it has been consumed.

Link: https://lore.kernel.org/20260730015809.3819606-1-warren.xiong@ugreen.com
Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Vishal Moola <vishal.moola@gmail.com>
Cc: Ye Liu <ye.liu@linux.dev>
Cc: Zhen Ni <zhen.ni@easystack.cn>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-prevent-page_owner_sort-from-truncating-input
+++ a/tools/mm/page_owner_sort.c
@@ -788,8 +788,7 @@ int main(int argc, char **argv)
 	}
 
 	fin = fopen(argv[optind], "r");
-	fout = fopen(argv[optind + 1], "w");
-	if (!fin || !fout) {
+	if (!fin) {
 		usage();
 		perror("open: ");
 		exit(1);
@@ -826,6 +825,13 @@ int main(int argc, char **argv)
 			goto out_free;
 	}
 
+	fout = fopen(argv[optind + 1], "w");
+	if (!fout) {
+		usage();
+		perror("open: ");
+		exit(1);
+	}
+
 	printf("loaded %d\n", list_size);
 
 	printf("sorting ....\n");
_

Patches currently in -mm which might be from warren.xiong@ugreen.com are

selftests-mm-read-memory-information-without-popen.patch

