Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D689130ADA;
	Thu, 31 Oct 2024 03:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730344510; cv=none; b=f4xSXAKIk06OnePj9uvmYFV3NB5xVwL52cr3wpbVtXQS9szVg4QsDaz+K6CTIekU9b1Ze8rCbV/yRP/8nGGHn5CwUddi29MdzKzGGGP7J9oqrrxJrf+W4e+0LKfgr4rHx00lmXT4DoBI35SiU0HlcK2IYQFJAvrC8mCV4AyKSPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730344510; c=relaxed/simple;
	bh=RNun+1385dh78flomN1Zt3f4oyVNDz/i7DwlZO8blGA=;
	h=Date:To:From:Subject:Message-Id; b=LX/wBOymzb1LWnUf4n+bnSkS+Y9DwLdxdPX3gUgeh0ROG7gJOZA1xCJ0+Pm4XN0S+NZM9CYzCF75vqlJiTkoI8I69PK6sqnzA6LQgbefFWzfwo6CRcQ3Mu2wX7ij7kzgdMbkObnW/FM8KcLzFP30tdNrbPsx9Mo3yN0ePtvQ+Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ryinw+Ng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ryinw+Ng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B691FC4CECE;
	Thu, 31 Oct 2024 03:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730344509;
	bh=RNun+1385dh78flomN1Zt3f4oyVNDz/i7DwlZO8blGA=;
	h=Date:To:From:Subject:From;
	b=Ryinw+NgM/0gtI2jOUwD0Tw/Bn74LXORWvMrcuuJL6tqdKMTw6tzPsIaYlBFQROiT
	 gQTo8SzhWMRuIY4b+8nxwAzHcO0OdKIu8VtHTmS2W9qvTwdYwHJHnsHnY/SLGgDv6c
	 0HqaYEl13TYmeU+HBgKZ6FmY8XyjT5N60mDd1IpY=
Date: Wed, 30 Oct 2024 20:15:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,herton@redhat.com,wladislav.kw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-mm-werror-fixes-in-page-types-slabinfo.patch removed from -mm tree
Message-Id: <20241031031509.B691FC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: -Werror fixes in page-types/slabinfo
has been removed from the -mm tree.  Its filename was
     tools-mm-werror-fixes-in-page-types-slabinfo.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wladislav Wiebe <wladislav.kw@gmail.com>
Subject: tools/mm: -Werror fixes in page-types/slabinfo
Date: Tue, 22 Oct 2024 19:21:13 +0200

Commit e6d2c436ff693 ("tools/mm: allow users to provide additional
cflags/ldflags") passes now CFLAGS to Makefile.  With this, build systems
with default -Werror enabled found:

slabinfo.c:1300:25: error: ignoring return value of 'chdir'
declared with attribute 'warn_unused_result' [-Werror=unused-result]
                         chdir("..");
                         ^~~~~~~~~~~
page-types.c:397:35: error: format '%lu' expects argument of type
'long unsigned int', but argument 2 has type 'uint64_t'
{aka 'long long unsigned int'} [-Werror=format=]
                         printf("%lu\t", mapcnt0);
                                 ~~^     ~~~~~~~
..

Fix page-types by using PRIu64 for uint64_t prints and check in slabinfo
for return code on chdir("..").

Link: https://lkml.kernel.org/r/c1ceb507-94bc-461c-934d-c19b77edd825@gmail.com
Fixes: e6d2c436ff69 ("tools/mm: allow users to provide additional cflags/ldflags")
Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Herton R. Krzesinski <herton@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    9 +++++----
 tools/mm/slabinfo.c   |    4 +++-
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/tools/mm/page-types.c~tools-mm-werror-fixes-in-page-types-slabinfo
+++ a/tools/mm/page-types.c
@@ -22,6 +22,7 @@
 #include <time.h>
 #include <setjmp.h>
 #include <signal.h>
+#include <inttypes.h>
 #include <sys/types.h>
 #include <sys/errno.h>
 #include <sys/fcntl.h>
@@ -391,9 +392,9 @@ static void show_page_range(unsigned lon
 		if (opt_file)
 			printf("%lx\t", voff);
 		if (opt_list_cgroup)
-			printf("@%llu\t", (unsigned long long)cgroup0);
+			printf("@%" PRIu64 "\t", cgroup0);
 		if (opt_list_mapcnt)
-			printf("%lu\t", mapcnt0);
+			printf("%" PRIu64 "\t", mapcnt0);
 		printf("%lx\t%lx\t%s\n",
 				index, count, page_flag_name(flags0));
 	}
@@ -419,9 +420,9 @@ static void show_page(unsigned long voff
 	if (opt_file)
 		printf("%lx\t", voffset);
 	if (opt_list_cgroup)
-		printf("@%llu\t", (unsigned long long)cgroup);
+		printf("@%" PRIu64 "\t", cgroup)
 	if (opt_list_mapcnt)
-		printf("%lu\t", mapcnt);
+		printf("%" PRIu64 "\t", mapcnt);
 
 	printf("%lx\t%s\n", offset, page_flag_name(flags));
 }
--- a/tools/mm/slabinfo.c~tools-mm-werror-fixes-in-page-types-slabinfo
+++ a/tools/mm/slabinfo.c
@@ -1297,7 +1297,9 @@ static void read_slab_dir(void)
 			slab->cpu_partial_free = get_obj("cpu_partial_free");
 			slab->alloc_node_mismatch = get_obj("alloc_node_mismatch");
 			slab->deactivate_bypass = get_obj("deactivate_bypass");
-			chdir("..");
+			if (chdir(".."))
+				fatal("Unable to chdir from slab ../%s\n",
+				      slab->name);
 			if (slab->name[0] == ':')
 				alias_targets++;
 			slab++;
_

Patches currently in -mm which might be from wladislav.kw@gmail.com are


