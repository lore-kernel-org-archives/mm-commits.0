Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61837493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CKQaCOcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2581C433C8;
	Mon, 11 Dec 2023 01:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257784;
	bh=1nXl0Vs+pMrhicnRhxyP1wdh8Vv+AGyc4dt4pi/xq2Y=;
	h=Date:To:From:Subject:From;
	b=CKQaCOcMPmJEwOaQ1Y56B6AYLUOmflPSwNbSpLdPxxGcbnoAV3O/b4wbMOP0PCxtD
	 0THQM7cX6d3OVfJTG2mEPsua2g0fERxMNjdtfJKmNFu+jD6xBvPxtFd/iB46zBBVTb
	 hrpsMCR0myz66sGtTD5SM7pwWqXwP5ESnMf2D/Cg=
Date: Sun, 10 Dec 2023 17:23:04 -0800
To: mm-commits@vger.kernel.org,v.narang@samsung.com,masahiroy@kernel.org,maninder1.s@samsung.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkstack-sort-output-by-size-and-function-name.patch removed from -mm tree
Message-Id: <20231211012304.B2581C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkstack: sort output by size and function name
has been removed from the -mm tree.  Its filename was
     checkstack-sort-output-by-size-and-function-name.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: checkstack: sort output by size and function name
Date: Mon, 20 Nov 2023 19:37:18 +0100

Sort output by size and in addition by function name.  This increases
readability for cases where there are many functions with the same stack
usage.

Link: https://lkml.kernel.org/r/20231120183719.2188479-3-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkstack.pl |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/scripts/checkstack.pl~checkstack-sort-output-by-size-and-function-name
+++ a/scripts/checkstack.pl
@@ -189,5 +189,20 @@ if ($total_size > $min_stack) {
 	push @stack, "$intro$total_size\n";
 }
 
-# Sort output by size (last field)
-print sort { ($b =~ /:\t*(\d+)$/)[0] <=> ($a =~ /:\t*(\d+)$/)[0] } @stack;
+# Sort output by size (last field) and function name if size is the same
+sub sort_lines {
+	my ($a, $b) = @_;
+
+	my $num_a = $1 if $a =~ /:\t*(\d+)$/;
+	my $num_b = $1 if $b =~ /:\t*(\d+)$/;
+	my $func_a = $1 if $a =~ / (.*):/;
+	my $func_b = $1 if $b =~ / (.*):/;
+
+	if ($num_a != $num_b) {
+		return $num_b <=> $num_a;
+	} else {
+		return $func_a cmp $func_b;
+	}
+}
+
+print sort { sort_lines($a, $b) } @stack;
_

Patches currently in -mm which might be from hca@linux.ibm.com are


