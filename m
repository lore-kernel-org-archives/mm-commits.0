Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C1B1C68A5
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 11:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711366499; cv=none; b=f3IC0+ahG8dAyp4NJJ/YbomXOuqqCnazn/uPVrdKNhT7UGOKB6pxs9htom5NgCOAtXnnrYnUjCuhUVxmIIDMHwc3QrmXach3jV7bGHUgfpJ3WVmXspF+UC9B9iQoXc1Z/+lS7oy3/aje2BgsUFtVpsbm7Rv+YDb1yN9x8UtPqQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711366499; c=relaxed/simple;
	bh=Di4LlSqaey6YAEOfxWJlZbZhRCpB0B1Fmqc/zr5a5tE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A1/iJqmN+U1QKClvWYs1urFpbaZGxR5Mp/ELZZWm6OvtgfaYw9kpPZ7IRTBIRi8/q8FZXjGkTRgehIhDsyFZKjHDTbbkbr/xPuUFZnA03u05kDh8h1bAiw/QrLMWZ2sI244y/fX5+KnwzbQmtLtwrEIc6P/3t5KpCX9B21jiTxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com; spf=pass smtp.mailfrom=perches.com; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=perches.com
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D98731A0A0D;
	Mon, 25 Mar 2024 10:16:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf20.hostedemail.com (Postfix) with ESMTPA id 5296020025;
	Mon, 25 Mar 2024 10:16:10 +0000 (UTC)
Message-ID: <962decb19a6be82a5f194a9c4ea761a50e56e9fc.camel@perches.com>
Subject: Re: +
 scripts-checkpatch-check-unused-parameters-for-function-like-macro.patch
 added to mm-nonmm-unstable branch
From: Joe Perches <joe@perches.com>
To: Mac Xu <mac.xxn@outlook.com>, Barry Song <21cnbao@gmail.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
 "apw@canonical.com" <apw@canonical.com>, "broonie@kernel.org"
 <broonie@kernel.org>,  "chenhuacai@loongson.cn" <chenhuacai@loongson.cn>,
 "chris@zankel.net" <chris@zankel.net>,  "corbet@lwn.net" <corbet@lwn.net>,
 "dwaipayanray1@gmail.com" <dwaipayanray1@gmail.com>, 
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,  "linux@roeck-us.net"
 <linux@roeck-us.net>, "lukas.bulwahn@gmail.com" <lukas.bulwahn@gmail.com>, 
 "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,  "v-songbaohua@oppo.com"
 <v-songbaohua@oppo.com>
Date: Mon, 25 Mar 2024 03:16:09 -0700
In-Reply-To: <MN0PR20MB47175742F5740D489481D3B9F3362@MN0PR20MB4717.namprd20.prod.outlook.com>
References: <ea9e38e6f49786ecb88f810a45c65238a2ec5641.camel@perches.com>
	 <20240323041401.6335-1-21cnbao@gmail.com>
	 <b92d6a4f17a17cc8586fea9fa72396c22d748d35.camel@perches.com>
	 <CAGsJ_4x+je5Tg9a92WXonaGqULQY56-KcijnWdO720qaefuWzw@mail.gmail.com>
	 <cbd117f445dfc92fd0bf2e0d200c32f628fe1c46.camel@perches.com>
	 <CAGsJ_4zb6qsXbij8eyyjNQroAaq-Bb0KzO0q66rFu-QgFgcr4w@mail.gmail.com>
	 <MN0PR20MB47175742F5740D489481D3B9F3362@MN0PR20MB4717.namprd20.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: o1o7onccmkr8c4dsw6be5jdz1cby631o
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 5296020025
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/q5ffLaDYiPYexYvkzcJTwzDQp94qnUYg=
X-HE-Tag: 1711361770-467332
X-HE-Meta: U2FsdGVkX1/wxbikW1CFkWrAWVi1X+lGAMnGiCGga5qSnJZ31U27dR9FItCskxBIKf9h1q6fK2IGE/umZ3qVLvNQHxUF31H/IPiNOtwKMcSf02dYilLCzLsRYI8GlWDMG2JjPEE+GfzI0kdBwhtsGgSTOiBZLLtw+rcNSbPubCJZKpmvReY5TgX5Sc4nvf8kfiMmi4TaERZbIidSg/KaIhZbSXk+pCIMcJHOFtDI6KdkMMxJt9irkfEU+VHOM0Le0UCC91ThtOaz0joUkXWAp29voD57QruUwODktJL93A3R/m2iET0pfTsEJ5aN/2mcI0XadfIbDwObwvPdCIslTV+B9qAC5prh80Uar8ZmBz0qnIRMYfixbX5s89duNq4N

On Mon, 2024-03-25 at 09:43 +0000, Mac Xu wrote:
> > On Sun, Mar 24, 2024 at 11:59=E2=80=AFAM Joe Perches <joe@perches.com> =
wrote:
> > >=20
> > > On Sun, 2024-03-24 at 11:40 +1300, Barry Song wrote:
> > > > On Sat, Mar 23, 2024 at 7:16=E2=80=AFPM Joe Perches <joe@perches.co=
m> wrote:
> > > > >=20
> > > > > On Sat, 2024-03-23 at 17:14 +1300, Barry Song wrote:
> > > > > > > > The patch titled
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Subject: scripts: checkpatch:=
 check unused parameters for function-like macro
> > > > > > > > has been added to the -mm mm-nonmm-unstable branch.  Its fi=
lename is
> > > > > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0scripts-checkpatch-check-unus=
ed-parameters-for-function-like-macro.patch
> > > > > > >=20
> > > > > > > Conceptually I don't disagree but I wonder what the false
> > > > > > > positive rate is.
> > > > > >=20
> > > > > > Hi Joe,
> > > > > >=20
> > > > > > If your concern is whether this script might produce inaccurate=
 reports, I'm confident that
> > > > > > the false positive rate is 0%. Xining, please correct me if I'm=
 mistaken.
> > > > >=20
> > > > > I presume it's low but non-zero.
> > > > >=20
> > > > > I think the false positives are going to be
> > > > > in some cases where a type is used as a macro
> > > > > argument in #ifdef/#else blocks
> > > > >=20
> > > > > #ifdef CONFIG_<FOO>
> > > > >=20
> > > > > #define foo(bar, baz, ...)              \
> > > > > static inline func##bar(baz, ...)       \
> > > > > {                                       \
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bar baz =3D ...  =
                 \
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0...              =
               \
> > > > > }
> > > > >=20
> > > > > #else
> > > > >=20
> > > > > #define foo(bar, baz, ...)
> > > > >=20
> > > > > #endif
> > > > >=20
> > > > > where it's not reasonably possible to use a
> > > > > static inline.
> > > >=20
> > > > I do find some exceptions such as include/uapi/linux/const.h
> > > >=20
> > > > #ifdef __ASSEMBLY__
> > > > #define _AC(X,Y)        X
> > > > #define _AT(T,X)        X
> > > > #else
> > > > #define __AC(X,Y)       (X##Y)
> > > > #define _AC(X,Y)        __AC(X,Y)
> > > > #define _AT(T,X)        ((T)(X))
> > > > #endif
> > > []
> > > > I'll check if Xining has some approach to detect this kind of ifdef=
/else/endif,
> > > > and remove those false positives.
> > >=20
> > > checkpatch isn't expected to be perfect.
> > >=20
> > > So I wouldn't worry about it, I just wondered if
> > > the exception rate is near the warning rate.
> > >=20
> > > I expect it's not, but if it is, then perhaps
> > > the warning isn't useful.
> > >=20
> > > Do you know how many existing cases there are in
> > > the kernel that might trip this warning?
> > I can find numerous cases, lots of func-like macros don't evaluate
> > their arguments.
> > They potentially might lead to build warnings.
> >=20
> > for example,
> >=20
> > WARNING: Parameter 'val' is not used in function-like macro #332:
> > FILE: arch/arm64/include/asm/fpsimd.h:332:
> > +#define sve_cond_update_zcr_vq(val, reg) do { } while (0)
> >=20
> > WARNING: Parameter 'reg' is not used in function-like macro #332:
> > FILE: arch/arm64/include/asm/fpsimd.h:332:
> > +#define sve_cond_update_zcr_vq(val, reg) do { } while (0)
> >=20
> > WARNING: Parameter 'p' is not used in function-like macro #21: FILE:
> > arch/arm64/include/asm/kprobes.h:21:
> > +#define flush_insn_slot(p)             do { } while (0)
> >=20
> > WARNING: Parameter 'vcpu' is not used in function-like macro #875:
> > FILE: arch/arm64/include/asm/kvm_host.h:875:
> > +#define vcpu_has_ptrauth(vcpu)         false
> >=20
> > WARNING: Parameter 'ex' is not used in function-like macro #120: FILE:
> > arch/arm64/include/asm/elf.h:120:
> > +#define compat_elf_read_implies_exec(ex, stk)  (stk =3D=3D EXSTACK_DEF=
AULT)
> >=20
> > WARNING: Parameter 'ex' is not used in function-like macro #161: FILE:
> > arch/arm64/include/asm/elf.h:161:
> > +#define SET_PERSONALITY(ex)                                           =
 \
> > +({                                                                    =
 \
> > +       clear_thread_flag(TIF_32BIT);                                  =
 \
> > +       current->personality &=3D ~READ_IMPLIES_EXEC;                  =
   \
> > +})
> >=20
> > WARNING: Parameter 'start' is not used in function-like macro #121:
> > FILE: arch/xtensa/include/asm/cacheflush.h:121:
> > +#define flush_cache_vunmap(start,end)          flush_cache_all()
> >=20
> >=20
> > WARNING: Parameter 'end' is not used in function-like macro #121:
> > FILE: arch/xtensa/include/asm/cacheflush.h:121:
> > +#define flush_cache_vunmap(start,end)          flush_cache_all()
> >=20
> >=20
> > WARNING: Parameter 'mm' is not used in function-like macro #140: FILE:
> > arch/xtensa/include/asm/cacheflush.h:140:
> > +#define flush_cache_mm(mm)                             do { } while (0=
)
> >=20
> >=20
> > WARNING: Parameter 'mm' is not used in function-like macro #141: FILE:
> > arch/xtensa/include/asm/cacheflush.h:141:
> > +#define flush_cache_dup_mm(mm)                         do { } while (0=
)
> >=20
> > ...
> >=20
> > And I do find some funny false positive:
> >=20
> > WARNING: Parameter '...' is not used in function-like macro #1090:
> > FILE: arch/arm64/include/asm/kvm_host.h:1090:
> > +#define kvm_call_hyp(f, ...) f(__VA_ARGS__)
> >=20
> > ...
> >=20
> > I think we at least need to fix this '...' case.
> >=20
> > And since sometimes we are reporting false positives, do we consider
> > downgrading it to WARN from ERROR?
> >=20
> > Thanks
> > Barry
>=20
> Hi Joe, Barry,
>=20
> I've fixed the false alarm case with "..." as suggested by Barry.
>=20
> Given the fact that this script named as "checkpatch", and a patch is abo=
ut=20
> the diff's rather than the full source code, this indicates that we are c=
hecking=20
> with limited information, which is likely to introduce false alarms and=
=20
> false positives, so, I'd suggest that we downgrade the ERROR to WARN.
>=20
> the changes in checkpatch.pl are as below:
> +if ($dstat =3D~ /^\+\s*#\s*define\s+$Ident\s*(\((?:[^\(\)]++|(?-1))*\))\=
s+(\S+.*)(\/\/.*)?/) {

Remove the "\s*" after $Ident otherwise this will
match on #define foo	(cast) (value) like:

drivers/acpi/acpica/aclocal.h:#define ACPI_GLOBAL_LOCK                (acpi=
_semaphore) (-1)

Why the // comment match and not a comment starting with /* ?

And you should use $balanced_parens

$Ident$balanced_parens\s*

as the macro definition with arguments is not required
to have whitespace after arguments

> +    my $params =3D $1 || "";
> +    my $body =3D $2 || "";
> +
> +    # get the individual params
> +    $params =3D~ tr/()//d;
> +    # remove leading and trailing whitespace
> +    $params =3D~ s/^\s+|\s+$//g;

trim

