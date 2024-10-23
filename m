Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A0A1FF7D7;
	Wed, 23 Oct 2024 23:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729727479; cv=none; b=ehIVETJVhf10pe2oPuQfk+0rEN4BA0BUQorEqc5UC+AU/LREnAVaRevMlO8DlGYDgDMnvPDi0ryjIqdPL4+ctSGfGdG4QnE0wIOWPxBsbCMUkGMXl4tsvfuQo/dW5rLgq710kry0dSepP9Be9lnbqVbwLf6B1TQyEpptEB5/LB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729727479; c=relaxed/simple;
	bh=h9eqOt0XALXQ1T+RGox89AQgIb+9cKJT71nHYHxnEfk=;
	h=Date:To:From:Subject:Message-Id; b=Xi4MGFkmiVhOuc3sJaamQ9OoPmpI3fnYzGELFgOJljfoIY30hIsB3fpks8/hX8H8F7EUQPNMk3dqxdzQUNYBuJc+zkOBZrncLIyaYsKw3mEPf0hMAm0V29v/UuVWYYWeZNI7rOxgNfQNMmEBZnKs/YWQMoDYi1QfjDJVhP6rC9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yhLep0eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yhLep0eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C9BC4CEE5;
	Wed, 23 Oct 2024 23:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729727478;
	bh=h9eqOt0XALXQ1T+RGox89AQgIb+9cKJT71nHYHxnEfk=;
	h=Date:To:From:Subject:From;
	b=yhLep0eME+7q35OXOklglLlSbbswQqTg7ciKkuHdgWOsSKfoQG+ouyF0bTpVylrvy
	 qEZDboVL7ADXTINj89IAxD97gwXH5SzGVrjzm/mf2ZgkCo4vhdl++SG4OG+aYR6cZf
	 prFuPqcCLaFYrrAGbYs08m8dTy5v7dYWaMitk+5s=
Date: Wed, 23 Oct 2024 16:51:17 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,herton@redhat.com,wladislav.kw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-werror-fixes-in-page-types-slabinfo.patch added to mm-hotfixes-unstable branch
Message-Id: <20241023235118.73C9BC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: -Werror fixes in page-types/slabinfo
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-mm-werror-fixes-in-page-types-slabinfo.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-werror-fixes-in-page-types-slabinfo.patch

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
Fixes: e6d2c436ff693 ("tools/mm: allow users to provide additional cflags/ldflags")
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

tools-mm-werror-fixes-in-page-types-slabinfo.patch

