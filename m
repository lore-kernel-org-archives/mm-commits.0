From: akpm@linux-foundation.org
Subject: + kobjects-mark-cleaned-up-kobjects-as-unitialized-2.patch added to -mm tree
Date: Mon, 10 Mar 2008 12:13:42 -0700
Message-ID: <200803101913.m2AJDgCe000976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60701 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbYCJTOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 15:14:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balajirrao@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org, laurent.riffard@free.fr


The patch titled
     kobjects: mark cleaned up kobjects as unitialized (2)
has been added to the -mm tree.  Its filename is
     kobjects-mark-cleaned-up-kobjects-as-unitialized-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: kobjects: mark cleaned up kobjects as unitialized (2)
=46rom: Balaji Rao <balajirrao@gmail.com>

On Saturday 08 March 2008 04:15:22 pm Laurent Riffard wrote:
> Le 07.03.2008 04:18, Stephen Rothwell a =C3=A9crit :
> > Hi all,
> >
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
>
> I've got a lot of "Slab corruption" with next-20060307 (actually a
> continuous flow of warnings) whereas next-20060306 is fine.
>
> [    3.045882] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> [    3.045885] Last user: [<c022460e>](vc_allocate+0x5a/0x136)
> [    3.045890] 000: 03 00 00 00 a0 00 00 00 40 00 00 00 40 01 00 00
> [    3.045902] 010: 00 00 00 00 00 00 85 de 00 50 85 de 00 00 85 de
> [    3.055247] Slab corruption: size-512 start=3Ddefb5060, len=3D512
> [    3.056465] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> [    3.057363] Last user: [<c022789b>](device_release+0x36/0x58)
> [    3.058594] 0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
> [    3.060109] Single bit error detected. Probably bad RAM.
> [    3.061353] Run memtest86+ or a similar memory test tool.
> [    3.062501] Next obj: start=3Ddefb5278, len=3D512
> [    3.063596] Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
> [    3.064751] Last user: [<c022460e>](vc_allocate+0x5a/0x136)
> [    3.065447] 000: 04 00 00 00 a0 00 00 00 40 00 00 00 40 01 00 00
> [    3.066965] 010: 00 00 00 00 00 80 85 de 00 d0 85 de 00 80 85 de
> [    3.074109] Slab corruption: size-512 start=3Ddefb56a8, len=3D512
> [    3.075336] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
> [    3.076510] Last user: [<c022789b>](device_release+0x36/0x58)
> [    3.077360] 0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6a 6b 6b 6b 6b 6b 6b 6b
> [    3.078885] Single bit error detected. Probably bad RAM.
> [    3.080015] Run memtest86+ or a similar memory test tool.
>
> I did a bisection:
>
> 5a428808720b31026890d3ff71fbd891d9a94fd6 is first bad commit
> commit 5a428808720b31026890d3ff71fbd891d9a94fd6
> Author: Balaji Rao <balajirrao@gmail.com>
> Date:   Thu Mar 6 22:23:18 2008 +0530
>
>     kobjects: mark cleaned up kobjects as unitialized
>
>     When I remove only the kvm-intel module without removing the kvm =
module
>     itself, I get an error saying that a kobject is trying to be
>     reinitialized. Its because of the fact that kvm reuses a kobject =
in
>     kvm_init when calling sysdev_register.
>
>     This patch fixes kobject_cleanup by marking the kobject as
> uninitialized when we cleanup to allow kobjects to be reused.
>
>     Signed-off-by: Balaji Rao <balajirrao@gmail.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> :040000 040000 c15d08d966391dec783d137558fad66d9c2da57b
> : eddea2ec69c014370cf98cc2fc7e24a8dc301e70 M     lib
>
> .config attached
> ~~
> laurent
Hi greg,

Apparently, its the wrong place to mark the kobject as uninitialized as=
 the
kobject could be freed by then. I've now moved it to the top of
kobject_cleanup(). This fixes the problem for me.

laurent, can you please revert the above commit , and apply this patch =
? Does
it help ?

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Cc: Laurent Riffard <laurent.riffard@free.fr>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN lib/kobject.c~kobjects-mark-cleaned-up-kobjects-as-unitialize=
d-2 lib/kobject.c
--- a/lib/kobject.c~kobjects-mark-cleaned-up-kobjects-as-unitialized-2
+++ a/lib/kobject.c
@@ -599,6 +599,9 @@ static void kobject_cleanup(struct kobje
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __FUNCTION__);
=20
+       /* Set the state to uninitialized */
+       kobj->state_initialized =3D 0;
+
 	if (t && !t->release)
 		pr_debug("kobject: '%s' (%p): does not have a release() "
 			 "function, it is broken and must be fixed.\n",
_

Patches currently in -mm which might be from balajirrao@gmail.com are

revert-gregkh-driver-kobjects-mark-cleaned-up-kobjects-as-unitialized.p=
atch
kobjects-mark-cleaned-up-kobjects-as-unitialized-2.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
