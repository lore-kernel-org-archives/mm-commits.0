Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CB57493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k73jBGlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC93AC433C9;
	Mon, 11 Dec 2023 01:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257785;
	bh=P6pCBEQkbZloqPx6/LCkWYZdwT20vm9d560Ft7IDpPs=;
	h=Date:To:From:Subject:From;
	b=k73jBGlV3JSlkFdAQg4iJyDIcOVSV4JxSFnwmcH1V4gS89qZyowg3FAOsAj2EVl3z
	 dyRGJdZafaL6qtvpdbeC37R+lG8uolGJXd6ofQ1tRIM/BwuI28zdrJ3CCZtNwqw+Kd
	 q0y9ZFyk7wSFsRMXxPKi3laCB5+At5WlLi5MQq+8=
Date: Sun, 10 Dec 2023 17:23:05 -0800
To: mm-commits@vger.kernel.org,v.narang@samsung.com,masahiroy@kernel.org,maninder1.s@samsung.com,hca@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkstack-allow-to-pass-minstacksize-parameter.patch removed from -mm tree
Message-Id: <20231211012305.AC93AC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkstack: allow to pass MINSTACKSIZE parameter
has been removed from the -mm tree.  Its filename was
     checkstack-allow-to-pass-minstacksize-parameter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Heiko Carstens <hca@linux.ibm.com>
Subject: checkstack: allow to pass MINSTACKSIZE parameter
Date: Mon, 20 Nov 2023 19:37:19 +0100

The checkstack script omits all functions with a stack usage of less than
100 bytes.  However the script already has support for a parameter which
allows to override the default, but it cannot be set with

$ make checkstack

Add a MINSTACKSIZE parameter which allows to change the default. This might
be useful in order to print the stack usage of all functions, or only those
with large stack usage:

$ make checkstack MINSTACKSIZE=0
$ make checkstack MINSTACKSIZE=800

Link: https://lkml.kernel.org/r/20231120183719.2188479-4-hca@linux.ibm.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Maninder Singh <maninder1.s@samsung.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Vaneet Narang <v.narang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/Makefile~checkstack-allow-to-pass-minstacksize-parameter
+++ a/Makefile
@@ -1576,7 +1576,8 @@ help:
 	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
 	 echo  ''
 	@echo  'Static analysers:'
-	@echo  '  checkstack      - Generate a list of stack hogs'
+	@echo  '  checkstack      - Generate a list of stack hogs and consider all functions'
+	@echo  '                    with a stack size larger than MINSTACKSIZE (default: 100)'
 	@echo  '  versioncheck    - Sanity check on version.h usage'
 	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
@@ -2016,9 +2017,10 @@ CHECKSTACK_ARCH := $(SUBARCH)
 else
 CHECKSTACK_ARCH := $(ARCH)
 endif
+MINSTACKSIZE	?= 100
 checkstack:
 	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
-	$(PERL) $(srctree)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
+	$(PERL) $(srctree)/scripts/checkstack.pl $(CHECKSTACK_ARCH) $(MINSTACKSIZE)
 
 kernelrelease:
 	@$(filechk_kernel.release)
_

Patches currently in -mm which might be from hca@linux.ibm.com are


