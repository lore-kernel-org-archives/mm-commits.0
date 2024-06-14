Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E9A1A2549
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 20:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718395210; cv=none; b=C/Ro98Sn681Zvzpzyc4EDQn1o9WdWv7nxqs0Py/VH5eYGAeJE5NkAVOP1sQE/OiliXy6+a5O+BkJuzc3lwpNIY1x7I7YL5XpuHPIlsQpsCtXs1jjVRol67cYazyA8A0ubk9HRCEkXu8okjJ4XYqEs1/Fr1XISLBeTQQdW5NJs7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718395210; c=relaxed/simple;
	bh=hVSW4Dt4moPr5JmNLWBiRLbKDJVT8uSN56UcqbaJR4M=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G2TFibko7KVBnJcIYO/VR9/gyEtmm60bCiMyEtxCED/F1kWfcPCki4NnmWCJQH0W04RjmI2trCu1rTb7oIgR74NCyUW8cPvPNoRHtcZDq07uY791iwsJ/eCNbX7IkcCSZCWFCbrzzWfnxnrT86KhGbV9147DmZxuDl0mtABugYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=hgTpaqtx; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="hgTpaqtx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1718395206; x=1718654406;
	bh=mqxg5MhI0wx6OQdblj4kZ4FD6HbJWf2y9YCxbFrn5LI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=hgTpaqtxRoCkTDJXKcaH6VV2LWjwC8kPWI6Pp3rKio1/iYoPo28wa1iNAV8IN90+b
	 Tty20ErjnkMmc8ED6C02zqMXHK2gFcgh9w51YuckR98NxZ3dBabUrCj/2Xcyeja0cb
	 ZI7sXn6Li+xlaXD+Qna3HTL1L/dbH2gSnxPCVT3srpFr2p4+FKdc9qB/3vrByDGseo
	 HPuEVVP8NzTk/30lrd8vTI77g7GGJ7qqFfqfgHThUHxjIPrJk7uIUnZ5Kijp+CevZF
	 hTL0qViGW+RCODJP99+657FJMJOaVhha4U79eSP4eoDpfKe2A+JfqVwJ+o4Dg8bR0N
	 eeajwmbHlgidg==
Date: Fri, 14 Jun 2024 20:00:02 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: =?utf-8?Q?Barnab=C3=A1s_P=C5=91cze?= <pobrn@protonmail.com>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org, keescook@chromium.org, jorgelo@chromium.org, jeffxu@google.com, hughd@google.com, dverkamp@chromium.org, dmitry.torokhov@gmail.com, david@readahead.eu
Subject: Re: [nacked] memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch removed from -mm tree
Message-ID: <qdcD-qU2Jfk6ImGOIaV4sWrbTZcHj44hNr454b2pd_SV8t4Bu1mnjsWXfYgW-c7tFW7bQowMRaKysMVcmWvGvUW3O20py_2H1jd7kNGT62Y=@protonmail.com>
In-Reply-To: <20240614182715.12694C2BD10@smtp.kernel.org>
References: <20240614182715.12694C2BD10@smtp.kernel.org>
Feedback-ID: 20568564:user:proton
X-Pm-Message-ID: 49afcb5920324f4f4c362c178c86c7a302831a09
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

2024. j=C3=BAnius 14., p=C3=A9ntek 20:27 keltez=C3=A9ssel, Andrew Morton <a=
kpm@linux-foundation.org> =C3=ADrta:

> The quilt patch titled
>      Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALIN=
G`
> has been removed from the -mm tree.  Its filename was
>      memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing.patch
>=20
> This patch was dropped because it was nacked

Hi Andrew,

do I gather it correctly that this is the final decision, and there is not =
much
willingness to try to remove this quirk of the `memfd_create()`? As far as =
I can tell,
the change was in linux-next for some time, did that uncover any problems? =
(If so,
I haven't been notified.)

Anyways, I believe I have laid out my arguments already, so I won't repeat =
them here,
and if this is final, then I will stop wasting everyone's time with further=
 emails. :-)


Regards,
Barnab=C3=A1s P=C5=91cze


>=20
> ------------------------------------------------------
> From: Barnab=C3=A1s P=C5=91cze <pobrn@protonmail.com>
> Subject: memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
> Date: Mon, 13 May 2024 19:15:47 +0000
>=20
> `MFD_NOEXEC_SEAL` should remove the executable bits and set `F_SEAL_EXEC`
> to prevent further modifications to the executable bits as per the commen=
t
> in the uapi header file:
>=20
>   not executable and sealed to prevent changing to executable
>=20
> However, currently, it also unsets `F_SEAL_SEAL`, essentially acting as a
> superset of `MFD_ALLOW_SEALING`.  Nothing implies that it should be so,
> and indeed up until the second version of the of the patchset[0] that
> introduced `MFD_EXEC` and `MFD_NOEXEC_SEAL`, `F_SEAL_SEAL` was not
> removed, however it was changed in the third revision of the patchset[1]
> without a clear explanation.
>=20
> This behaviour is suprising for application developers, there is no
> documentation that would reveal that `MFD_NOEXEC_SEAL` has the additional
> effect of `MFD_ALLOW_SEALING`.
>=20
> So do not remove `F_SEAL_SEAL` when `MFD_NOEXEC_SEAL` is requested.  This
> is technically an ABI break, but it seems very unlikely that an
> application would depend on this behaviour (unless by accident).
>=20
> [0]: https://lore.kernel.org/lkml/20220805222126.142525-3-jeffxu@google.c=
om/
> [1]: https://lore.kernel.org/lkml/20221202013404.163143-3-jeffxu@google.c=
om/
>=20
> Link: https://lkml.kernel.org/r/20240513191544.94754-1-pobrn@protonmail.c=
om
> Fixes: 105ff5339f49 ("mm/memfd: add MFD_NOEXEC_SEAL and MFD_EXEC")
> Signed-off-by: Barnab=C3=A1s P=C5=91cze <pobrn@protonmail.com>
> Reviewed-by: Jeff Xu <jeffxu@google.com>
> Reviewed-by: David Rheinsberg <david@readahead.eu>
> Cc: Daniel Verkamp <dverkamp@chromium.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Jeff Xu <jeffxu@google.com>
> Cc: Jorge Lucangeli Obes <jorgelo@chromium.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  mm/memfd.c                                 |    9 ++++-----
>  tools/testing/selftests/memfd/memfd_test.c |    2 +-
>  2 files changed, 5 insertions(+), 6 deletions(-)
>=20
> --- a/mm/memfd.c~memfd-mfd_noexec_seal-should-not-imply-mfd_allow_sealing
> +++ a/mm/memfd.c
> @@ -356,12 +356,11 @@ SYSCALL_DEFINE2(memfd_create,
>=20
>  =09=09inode->i_mode &=3D ~0111;
>  =09=09file_seals =3D memfd_file_seals_ptr(file);
> -=09=09if (file_seals) {
> -=09=09=09*file_seals &=3D ~F_SEAL_SEAL;
> +=09=09if (file_seals)
>  =09=09=09*file_seals |=3D F_SEAL_EXEC;
> -=09=09}
> -=09} else if (flags & MFD_ALLOW_SEALING) {
> -=09=09/* MFD_EXEC and MFD_ALLOW_SEALING are set */
> +=09}
> +
> +=09if (flags & MFD_ALLOW_SEALING) {
>  =09=09file_seals =3D memfd_file_seals_ptr(file);
>  =09=09if (file_seals)
>  =09=09=09*file_seals &=3D ~F_SEAL_SEAL;
> --- a/tools/testing/selftests/memfd/memfd_test.c~memfd-mfd_noexec_seal-sh=
ould-not-imply-mfd_allow_sealing
> +++ a/tools/testing/selftests/memfd/memfd_test.c
> @@ -1151,7 +1151,7 @@ static void test_noexec_seal(void)
>  =09=09=09    mfd_def_size,
>  =09=09=09    MFD_CLOEXEC | MFD_NOEXEC_SEAL);
>  =09mfd_assert_mode(fd, 0666);
> -=09mfd_assert_has_seals(fd, F_SEAL_EXEC);
> +=09mfd_assert_has_seals(fd, F_SEAL_SEAL | F_SEAL_EXEC);
>  =09mfd_fail_chmod(fd, 0777);
>  =09close(fd);
>  }
> _
>=20
> Patches currently in -mm which might be from pobrn@protonmail.com are
