Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848813A258
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810116; cv=none; b=uhauvGflH+VS8C2WnQbqnfnnI+VgNWaI+TCgXGVslSHQk/DRIJ2lsqvalY4TaCzvy06W692e9NItnvLchuk+K0Gd0r+5HHOeCzw+xB9aDC+kOzNWn8LyxCqWSVwgHjksIGwbAC53S4zMYpuBq2H4DpGq2wDb8eUdZQcx6T7O5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810116; c=relaxed/simple;
	bh=DEfmQtS53rkmZbvj3XyNLI9sZrkkGRLeJ/AnyrmKDP8=;
	h=Date:To:From:Subject:Message-Id; b=CGx9hGb6oRbm3QQCbyTlc69mkqTIrmKMlQe7oXD9h+NONnEyK2sKxW0ggTY/JuFwPlL9Jf1aKUyH9ZWN1Tgh3TpL9leiP7Thpb2+UIpgrTDcnNw5n1crsHvprW8iovrSyoRdxl/MUBzg8vQFWVQ4wor4ImpAG4K3oOiBVqRybv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=koUgUbEn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="koUgUbEn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA9AC4CEEB;
	Sun, 14 Sep 2025 00:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810114;
	bh=DEfmQtS53rkmZbvj3XyNLI9sZrkkGRLeJ/AnyrmKDP8=;
	h=Date:To:From:Subject:From;
	b=koUgUbEnaT8cpmZjCo9EPdTusPa0NJrLbTPENiZwCcrj2bbnglgIwb/Kee6wxLQoA
	 zOgWnSncXInC7gaHJAaalzyPgc4YUi/de/p90aFF9R9rSg2m2BOX8+XFqNHu357MAW
	 d4LWBMIFQJZAqpHdFBtjUX102IlxJ13xUXUp8jqQ=
Date: Sat, 13 Sep 2025 17:35:13 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] alloc_tag-use-str_on_off-helper.patch removed from -mm tree
Message-Id: <20250914003514.5FA9AC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: use str_on_off() helper
has been removed from the -mm tree.  Its filename was
     alloc_tag-use-str_on_off-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: alloc_tag: use str_on_off() helper
Date: Thu, 14 Aug 2025 17:38:27 +0800

Replace the ternary (enable ?  "on" : "off") with the str_on_off() helper
from string_choices.h.  This improves readability by replacing the
three-operand ternary with a single function call, ensures consistent
string output, and allows potential string deduplication by the linker,
resulting in a slightly smaller binary.

Link: https://lkml.kernel.org/r/20250814093827.237980-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/alloc_tag.c~alloc_tag-use-str_on_off-helper
+++ a/lib/alloc_tag.c
@@ -9,6 +9,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_buf.h>
 #include <linux/seq_file.h>
+#include <linux/string_choices.h>
 #include <linux/vmalloc.h>
 #include <linux/kmemleak.h>
 
@@ -726,7 +727,7 @@ static int __init setup_early_mem_profil
 		}
 		mem_profiling_support = true;
 		pr_info("Memory allocation profiling is enabled %s compression and is turned %s!\n",
-			compressed ? "with" : "without", enable ? "on" : "off");
+			compressed ? "with" : "without", str_on_off(enable));
 	}
 
 	if (enable != mem_alloc_profiling_enabled()) {
_

Patches currently in -mm which might be from visitorckw@gmail.com are


