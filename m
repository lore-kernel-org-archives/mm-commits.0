From: akpm@linux-foundation.org
Subject: + uml-fix-build.patch added to -mm tree
Date: Thu, 14 Oct 2010 14:21:13 -0700
Message-ID: <201010142121.o9ELLDce019974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab0JNVWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 17:22:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jdike@addtoit.com, rusty@rustcorp.com.au, tiwai@suse.de, toralf.foerster@gmx.de


The patch titled
     uml: fix build
has been added to the -mm tree.  Its filename is
     uml-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: uml: fix build
=46rom: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

=46ix a build error introduced by d6d1b650ae6acce73d55dd024 ("param: si=
mple
locking for sysfs-writable charp parameters").

  CC      arch/um/kernel/trap.o
arch/um/drivers/hostaudio_kern.c: In function \u2018hostaudio_open\u201=
9:
arch/um/drivers/hostaudio_kern.c:204: error: \u2018__param_dsp\u2019 un=
declared (first use in this function)
arch/um/drivers/hostaudio_kern.c:204: error: (Each undeclared identifie=
r is reported only once
arch/um/drivers/hostaudio_kern.c:204: error: for each function it appea=
rs in.)
arch/um/drivers/hostaudio_kern.c: In function \u2018hostmixer_open_mixd=
ev\u2019:
arch/um/drivers/hostaudio_kern.c:265: error: \u2018__param_mixer\u2019 =
undeclared (first use in this function)
arch/um/drivers/hostaudio_kern.c:272: error: \u2018__param_dsp\u2019 un=
declared (first use in this function)

Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Tested-by: Toralf F=F6rster <toralf.foerster@gmx.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/hostaudio_kern.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN arch/um/drivers/hostaudio_kern.c~uml-fix-build arch/um/driver=
s/hostaudio_kern.c
--- a/arch/um/drivers/hostaudio_kern.c~uml-fix-build
+++ a/arch/um/drivers/hostaudio_kern.c
@@ -40,6 +40,11 @@ static char *mixer =3D HOSTAUDIO_DEV_MIXER
 "    This is used to specify the host mixer device to the hostaudio dr=
iver.\n"\
 "    The default is \"" HOSTAUDIO_DEV_MIXER "\".\n\n"
=20
+module_param(dsp, charp, 0644);
+MODULE_PARM_DESC(dsp, DSP_HELP);
+module_param(mixer, charp, 0644);
+MODULE_PARM_DESC(mixer, MIXER_HELP);
+
 #ifndef MODULE
 static int set_dsp(char *name, int *add)
 {
@@ -56,15 +61,6 @@ static int set_mixer(char *name, int *ad
 }
=20
 __uml_setup("mixer=3D", set_mixer, "mixer=3D<mixer device>\n" MIXER_HE=
LP);
-
-#else /*MODULE*/
-
-module_param(dsp, charp, 0644);
-MODULE_PARM_DESC(dsp, DSP_HELP);
-
-module_param(mixer, charp, 0644);
-MODULE_PARM_DESC(mixer, MIXER_HELP);
-
 #endif
=20
 /* /dev/dsp file operations */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co=
=2Ejp are

uml-fix-build.patch
linux-next.patch
x86-enable-arch_dma_addr_t_64bit-with-x86_64-highmem64g.patch
powerpc-enable-arch_dma_addr_t_64bit-with-arch_phys_addr_t_64bit.patch
tile-enable-arch_dma_addr_t_64bit.patch
mips-enable-arch_dma_addr_t_64bit-with-highmem-64bit_phys_addr-64bit.pa=
tch
s390-enable-arch_dma_addr_t_64bit-with-64bit.patch
alpha-enable-arch_dma_addr_t_64bit.patch
uml-define-config_no_dma.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
sparc-remove-dma64_addr_t-usage.patch
mips-remove-dma64_addr_t-usage.patch
alpha-remove-dma64_addr_t-usage.patch
remove-dma64_addr_t.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
