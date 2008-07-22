From: akpm@linux-foundation.org
Subject: - markers-fix-duplicate-modpost-entry.patch removed from -mm tree
Date: Tue, 22 Jul 2008 14:32:27 -0700
Message-ID: <200807222132.m6MLWROO018717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbYGVVe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 17:34:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: compudj@krystal.dyndns.org, mathieu.desnoyers@polymtl.ca, roland@redhat.com, stable@kernel.org, t-nishiie@np.css.fujitsu.com, wenji.huang@oracle.com, mm-commits@vger.kernel.org


The patch titled
     markers: fix duplicate modpost entry
has been removed from the -mm tree.  Its filename was
     markers-fix-duplicate-modpost-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: markers: fix duplicate modpost entry
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>

When a kernel was rebuilt, the previous Module.markers was not cleared. 
It caused markers with different format strings to appear as duplicates
when a markers was changed.  This problem is present since
scripts/mod/modpost.c started to generate Module.markers, commit
b2e3e658b344c6bcfb8fb694100ab2f2b5b2edb0

It therefore applies to 2.6.25, 2.6.26 and linux-next.

I merely merged the patches from Roland, Wenji and Takashi here.

Credits to
Roland McGrath <roland@redhat.com>
Wenji Huang <wenji.huang@oracle.com>
and
Takashi Nishiie <t-nishiie@np.css.fujitsu.com>

for providing the individual fixes.

- Changelog :
  - Integrated Takashi's Makefile modification to clear Module.markers upon
    make clean.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Roland McGrath <roland@redhat.com>
Cc: Wenji Huang <wenji.huang@oracle.com>
Cc: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile                 |    3 ++-
 scripts/Makefile.modpost |    1 +
 scripts/mod/modpost.c    |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN Makefile~markers-fix-duplicate-modpost-entry Makefile
--- a/Makefile~markers-fix-duplicate-modpost-entry
+++ a/Makefile
@@ -1148,7 +1148,8 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' -o -name 'modules.order' \) \
+		-o -name '*.symtypes' -o -name 'modules.order' \
+		-o -name 'Module.markers' \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
diff -puN scripts/Makefile.modpost~markers-fix-duplicate-modpost-entry scripts/Makefile.modpost
--- a/scripts/Makefile.modpost~markers-fix-duplicate-modpost-entry
+++ a/scripts/Makefile.modpost
@@ -101,6 +101,7 @@ quiet_cmd_kernel-mod = MODPOST $@
       cmd_kernel-mod = $(modpost) $@
 
 vmlinux.o: FORCE
+	@rm -fr $(kernelmarkersfile)
 	$(call cmd,kernel-mod)
 
 # Declare generated files as targets for modpost
diff -puN scripts/mod/modpost.c~markers-fix-duplicate-modpost-entry scripts/mod/modpost.c
--- a/scripts/mod/modpost.c~markers-fix-duplicate-modpost-entry
+++ a/scripts/mod/modpost.c
@@ -1992,7 +1992,8 @@ static void read_markers(const char *fna
 			mod->skip = 1;
 		}
 
-		add_marker(mod, marker, fmt);
+		if (!mod->skip)
+			add_marker(mod, marker, fmt);
 	}
 	return;
 fail:
_

Patches currently in -mm which might be from compudj@krystal.dyndns.org are

origin.patch

