From: akpm@linux-foundation.org
Subject: + sh-sh4a-bring-back-tmu3_device-early-device.patch added
 to -mm tree
Date: Mon, 01 Jun 2020 17:55:24 -0700
Message-ID: <20200602005524.LfVXIDBkg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFBAz0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Jun 2020 20:55:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amodra@gmail.com, bin.meng@windriver.com, chenzhou10@huawei.com, dalias@libc.org, geert+renesas@glider.be, glaubitz@physik.fu-berlin.de, krzk@kernel.org, kuninori.morimoto.gx@renesas.com, mm-commits@vger.kernel.org, romain.naour@gmail.com, sam@ravnborg.org, ysato@users.sourceforge.jp


The patch titled
     Subject: sh: sh4a: bring back tmu3_device early device
has been added to the -mm tree.  Its filename is
     sh-sh4a-bring-back-tmu3_device-early-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-sh4a-bring-back-tmu3_device=
-early-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-sh4a-bring-back-tmu3_device=
-early-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Krzysztof Kozlowski <krzk@kernel.org>
Subject: sh: sh4a: bring back tmu3_device early device

Commit 1399c195ef50 ("sh: Switch to new style TMU device") converted
tmu3_device platform device to new style of platform data but removed it
from sh7786_early_devices array effectively removing last three timers and
causing a warning:

    arch/sh/kernel/cpu/sh4a/setup-sh7786.c:243:31:
        warning: =E2=80=98tmu3_device=E2=80=99 defined but not used [-Wunus=
ed-variable]

Fixes: 1399c195ef50 ("sh: Switch to new style TMU device")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Alan Modra <amodra@gmail.com>
Cc: Bin Meng <bin.meng@windriver.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Romain Naour <romain.naour@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c~sh-sh4a-bring-back-tmu3_device=
-early-device
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -391,6 +391,7 @@ static struct platform_device *sh7786_ea
 	&tmu0_device,
 	&tmu1_device,
 	&tmu2_device,
+	&tmu3_device,
 };
=20
 static struct platform_device *sh7786_devices[] __initdata =3D {
_

Patches currently in -mm which might be from krzk@kernel.org are

sh-sh4a-bring-back-tmu3_device-early-device.patch
