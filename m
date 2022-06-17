Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DC1C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 01:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379330AbiFQBEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 21:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiFQBEm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 21:04:42 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C635EBD7
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 18:04:39 -0700 (PDT)
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220617010433epoutp0315327c5bccaba3bcdda717802b076994~5QuFr6rHw1082710827epoutp038
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 01:04:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220617010433epoutp0315327c5bccaba3bcdda717802b076994~5QuFr6rHw1082710827epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655427874;
        bh=fZ5PdTEZ2dv6QMHZFJ/+mcVRpujUnXw0UKQc93syBuY=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=EmphTzMoEzc2rH1pINwRcMtkpIojx3ibpBW/zJP347mTp9jFP54R+AV7IgqMA3IjH
         vVIrH+tXjkhAzxRNb/fvnXlg0BYZGc9xx96eW9JoLsxjUcHd4dLEoiy6X2VPH0h5Pr
         Z1kxNQYM/KKcPtTgPwpch1qqJpikYY7UX7Q0jZvI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220617010433epcas1p19071227c1d73a8b9e0f6af383382cecb~5QuFLe_rf2611426114epcas1p16;
        Fri, 17 Jun 2022 01:04:33 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.36.225]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4LPLRP0Gzhz4x9Pv; Fri, 17 Jun
        2022 01:04:33 +0000 (GMT)
X-AuditID: b6c32a37-127ff70000002736-a1-62abd320c1d6
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.FD.10038.023DBA26; Fri, 17 Jun 2022 10:04:32 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [to-be-updated]
 zram_drv-add-__gfp_nomemalloc-not-to-use-alloc_no_watermarks.patch removed
 from -mm tree
Sender: Jaewon Kim <jaewon31.kim@samsung.com>
From:   Jaewon Kim <jaewon31.kim@samsung.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        YongTaek Lee <ytk.lee@samsung.com>,
        Sooyong Suk <s.suk@samsung.com>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "avromanov@sberdevices.ru" <avromanov@sberdevices.ru>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20220608192933.5279DC34116@smtp.kernel.org>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20220617010432epcms1p348c725abef40bfd539cc29c82a64f6ef@epcms1p3>
Date:   Fri, 17 Jun 2022 10:04:32 +0900
X-CMS-MailID: 20220617010432epcms1p348c725abef40bfd539cc29c82a64f6ef
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 101P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGJsWRmVeSWpSXmKPExsWy7bCmrq7C5dVJBls321jMWb+GzaL/8n5G
        i5eHNC2WfX3PbvF64gVWiw0ts9gtFv29wm6xe+MiNovH67kdOD1mN1xk8di0qpPN48SM3ywe
        fVtWMXpcWHuX1WPnp82sHp83yQWwR2XbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpa
        mCsp5CXmptoqufgE6Lpl5gAdpqRQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkpMCvQ
        K07MLS7NS9fLSy2xMjQwMDIFKkzIznj9t5m54HRQxa2zEQ2ML/y7GDk5JARMJDY/bWbuYuTi
        EBLYwSgxZe0S9i5GDg5eAUGJvzuEQUxhgUqJx5vCQcqFBJQkzv64wg5iCwvoSjR1r2YBsdkE
        tCXeL5jECjJGROAnk0Tn89VsEPN5JWa0P2WBsKUlti/fyghicwpYSpxuu84OEReVuLn6LZz9
        /th8RghbRKL13llmCFtQ4sHP3VBxKYlz3ceZQG6TEIiQeLFHHSKcI/F+5xxWCNtc4tmGFrCR
        vAK+EksuLQOLswioSnT9Xg810kXi+ekZYGcyA92/bOFrZpCRzAKaEut36UOUKErs/D2XEeaT
        ho2/2dHZzAJ8Eu++9rDCxHfMe8IEYatJtDz7ChWXkfj77xmU7SGxuWU7+wRGxVmIcJ6F5IhZ
        CEcsYGRexSiWWlCcm55abFhgDI/Z5PzcTYzgBKplvoNx2tsPeocYmTgYDzFKcDArifCaBa9M
        EuJNSaysSi3Kjy8qzUktPsRoCvT+RGYp0eR8YArPK4k3NLE0MDEzMrEwtjQ2UxLnXTXtdKKQ
        QHpiSWp2ampBahFMHxMHp1QDU3wxv/7O8IzIvXMdTuuv+CbAkK3d+bA2cN/3/Xxn1n6+GBpy
        +uyGLRIfWDhtawOd3h7/fEjAW1n28A9tjVN6194bVbd/PenR86yFpyqPgVHA7oOwdbwLt9is
        j/kHvFk3TXqm5LLNexlrs1e6tseuo9F7PMLV/ZfOuv84gilwjjWDmE3tX7YAXVfz9TMbdjmF
        vZe8bKpVz+Dbx3HcX7vcXYLZabHSgVlrVmw4VrSzljGXIfP/2pVLRP6WPnnAEjbVOqRCsGxr
        z9Lj6hs+qwuovWqKCLVeeic8NyObUVH98z0DkaSgxeqKDE6m9vYy19YkVixf5bzoy8uoT+tO
        /Vofnq++Qj1Yvj5vXUHI7ktKLMUZiYZazEXFiQC1R51fKQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220608192938epcas1p3eb403705cf57aa56be63a19423bbae8c
References: <20220608192933.5279DC34116@smtp.kernel.org>
        <CGME20220608192938epcas1p3eb403705cf57aa56be63a19423bbae8c@epcms1p3>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Dear Andrew Morton

Sorry to bother you
But I'm confused about the following dropped to be merged thing.
Can I just wait or I should give up that patch?


Dear Minchan Kim

I'm sorry but I got reported this atomic alloation failure again recently.
I asked network develeper to implement a work around though.
I just hope to get your signed-off if you don't mind.

Thank you
Jaewon Kim

=C2=A0=0D=0A=C2=A0=0D=0A---------=20Original=20Message=20---------=0D=0ASen=
der=20:=20Andrew=20Morton=C2=A0<akpm=40linux-foundation.org>=0D=0ADate=20:=
=202022-06-09=2004:29=20(GMT+9)=0D=0ATitle=20:=20=5Bto-be-updated=5D=20zram=
_drv-add-__gfp_nomemalloc-not-to-use-alloc_no_watermarks.patch=20removed=20=
from=20-mm=20tree=0D=0A=C2=A0=0D=0AThe=C2=A0quilt=C2=A0patch=C2=A0titled=0D=
=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Subject:=C2=A0zram_drv:=C2=A0add=C2=A0__GF=
P_NOMEMALLOC=C2=A0not=C2=A0to=C2=A0use=C2=A0ALLOC_NO_WATERMARKS=0D=0Ahas=C2=
=A0been=C2=A0removed=C2=A0from=C2=A0the=C2=A0-mm=C2=A0tree.=C2=A0=C2=A0Its=
=C2=A0filename=C2=A0was=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0zram_drv-add-__g=
fp_nomemalloc-not-to-use-alloc_no_watermarks.patch=0D=0A=0D=0AThis=C2=A0pat=
ch=C2=A0was=C2=A0dropped=C2=A0because=C2=A0an=C2=A0updated=C2=A0version=C2=
=A0will=C2=A0be=C2=A0merged=0D=0A=0D=0A------------------------------------=
------------------=0D=0AFrom:=C2=A0Jaewon=C2=A0Kim=C2=A0<jaewon31.kim=40sam=
sung.com>=0D=0ASubject:=C2=A0zram_drv:=C2=A0add=C2=A0__GFP_NOMEMALLOC=C2=A0=
not=C2=A0to=C2=A0use=C2=A0ALLOC_NO_WATERMARKS=0D=0ADate:=C2=A0Fri,=C2=A03=
=C2=A0Jun=C2=A02022=C2=A014:57:47=C2=A0+0900=0D=0A=0D=0AAtomic=C2=A0page=C2=
=A0allocation=C2=A0failures=C2=A0sometimes=C2=A0happen,=C2=A0and=C2=A0most=
=C2=A0of=C2=A0them=C2=A0seem=C2=A0to=0D=0Aoccur=C2=A0during=C2=A0boot=C2=A0=
time.=0D=0A=0D=0A=5B=C2=A0=C2=A0=C2=A059.707645=5D=C2=A0system_server:=C2=
=A0page=C2=A0allocation=C2=A0failure:=C2=A0order:0,=C2=A0mode:0xa20(GFP_ATO=
MIC),=C2=A0nodemask=3D(null),cpuset=3Dforeground-boost,mems_allowed=3D0=0D=
=0A=5B=C2=A0=C2=A0=C2=A059.707676=5D=C2=A0CPU:=C2=A05=C2=A0PID:=C2=A01209=
=C2=A0Comm:=C2=A0system_server=C2=A0Tainted:=C2=A0G=C2=A0S=C2=A0O=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A05.4.161-qgki-24219806-abA236USQU0AVE1=C2=A0=231=
=0D=0A=5B=C2=A0=C2=A0=C2=A059.707691=5D=C2=A0Call=C2=A0trace:=0D=0A=5B=C2=
=A0=C2=A0=C2=A059.707702=5D=C2=A0=C2=A0dump_backtrace.cfi_jt+0x0/0x4=0D=0A=
=5B=C2=A0=C2=A0=C2=A059.707712=5D=C2=A0=C2=A0show_stack+0x18/0x24=0D=0A=5B=
=C2=A0=C2=A0=C2=A059.707719=5D=C2=A0=C2=A0dump_stack+0xa4/0xe0=0D=0A=5B=C2=
=A0=C2=A0=C2=A059.707728=5D=C2=A0=C2=A0warn_alloc+0x114/0x194=0D=0A=5B=C2=
=A0=C2=A0=C2=A059.707734=5D=C2=A0=C2=A0__alloc_pages_slowpath+0x828/0x83c=
=0D=0A=5B=C2=A0=C2=A0=C2=A059.707740=5D=C2=A0=C2=A0__alloc_pages_nodemask+0=
x2b4/0x310=0D=0A=5B=C2=A0=C2=A0=C2=A059.707747=5D=C2=A0=C2=A0alloc_slab_pag=
e+0x40/0x5c8=0D=0A=5B=C2=A0=C2=A0=C2=A059.707753=5D=C2=A0=C2=A0new_slab+0x4=
04/0x420=0D=0A=5B=C2=A0=C2=A0=C2=A059.707759=5D=C2=A0=C2=A0___slab_alloc+0x=
224/0x3b0=0D=0A=5B=C2=A0=C2=A0=C2=A059.707765=5D=C2=A0=C2=A0__kmalloc+0x37c=
/0x394=0D=0A=5B=C2=A0=C2=A0=C2=A059.707773=5D=C2=A0=C2=A0context_struct_to_=
string+0x110/0x1b8=0D=0A=5B=C2=A0=C2=A0=C2=A059.707778=5D=C2=A0=C2=A0contex=
t_add_hash+0x6c/0xc8=0D=0A=5B=C2=A0=C2=A0=C2=A059.707785=5D=C2=A0=C2=A0secu=
rity_compute_sid.llvm.13699573597798246927+0x508/0x5d8=0D=0A=5B=C2=A0=C2=A0=
=C2=A059.707792=5D=C2=A0=C2=A0security_transition_sid+0x2c/0x38=0D=0A=5B=C2=
=A0=C2=A0=C2=A059.707804=5D=C2=A0=C2=A0selinux_socket_create+0xa0/0xd8=0D=
=0A=5B=C2=A0=C2=A0=C2=A059.707811=5D=C2=A0=C2=A0security_socket_create+0x68=
/0xbc=0D=0A=5B=C2=A0=C2=A0=C2=A059.707818=5D=C2=A0=C2=A0__sock_create+0x8c/=
0x2f8=0D=0A=5B=C2=A0=C2=A0=C2=A059.707823=5D=C2=A0=C2=A0__sys_socket+0x94/0=
x19c=0D=0A=5B=C2=A0=C2=A0=C2=A059.707829=5D=C2=A0=C2=A0__arm64_sys_socket+0=
x20/0x30=0D=0A=5B=C2=A0=C2=A0=C2=A059.707836=5D=C2=A0=C2=A0el0_svc_common+0=
x100/0x1e0=0D=0A=5B=C2=A0=C2=A0=C2=A059.707841=5D=C2=A0=C2=A0el0_svc_handle=
r+0x68/0x74=0D=0A=5B=C2=A0=C2=A0=C2=A059.707848=5D=C2=A0=C2=A0el0_svc+0x8/0=
xc=0D=0A=5B=C2=A0=C2=A0=C2=A059.707853=5D=C2=A0Mem-Info:=0D=0A=5B=C2=A0=C2=
=A0=C2=A059.707890=5D=C2=A0active_anon:223569=C2=A0inactive_anon:74412=C2=
=A0isolated_anon:0=0D=0A=5B=C2=A0=C2=A0=C2=A059.707890=5D=C2=A0=C2=A0active=
_file:51395=C2=A0inactive_file:176622=C2=A0isolated_file:0=0D=0A=5B=C2=A0=
=C2=A0=C2=A059.707890=5D=C2=A0=C2=A0unevictable:1018=C2=A0dirty:211=C2=A0wr=
iteback:4=C2=A0unstable:0=0D=0A=5B=C2=A0=C2=A0=C2=A059.707890=5D=C2=A0=C2=
=A0slab_reclaimable:14398=C2=A0slab_unreclaimable:61909=0D=0A=5B=C2=A0=C2=
=A0=C2=A059.707890=5D=C2=A0=C2=A0mapped:134779=C2=A0shmem:1231=C2=A0pagetab=
les:26706=C2=A0bounce:0=0D=0A=5B=C2=A0=C2=A0=C2=A059.707890=5D=C2=A0=C2=A0f=
ree:528=C2=A0free_pcp:844=C2=A0free_cma:147=0D=0A=5B=C2=A0=C2=A0=C2=A059.70=
7900=5D=C2=A0Node=C2=A00=C2=A0active_anon:894276kB=C2=A0inactive_anon:29764=
8kB=C2=A0active_file:205580kB=C2=A0inactive_file:706488kB=C2=A0unevictable:=
4072kB=C2=A0isolated(anon):0kB=C2=A0isolated(file):0kB=C2=A0mapped:539116kB=
=C2=A0dirty:844kB=C2=A0writeback:16kB=C2=A0shmem:4924kB=C2=A0writeback_tmp:=
0kB=C2=A0unstable:0kB=C2=A0all_unreclaimable?=C2=A0no=0D=0A=5B=C2=A0=C2=A0=
=C2=A059.707912=5D=C2=A0Normal=C2=A0free:2112kB=C2=A0min:7244kB=C2=A0low:68=
892kB=C2=A0high:72180kB=C2=A0active_anon:893140kB=C2=A0inactive_anon:297660=
kB=C2=A0active_file:204740kB=C2=A0inactive_file:706396kB=C2=A0unevictable:4=
072kB=C2=A0writepending:860kB=C2=A0present:3626812kB=C2=A0managed:3288700kB=
=C2=A0mlocked:4068kB=C2=A0kernel_stack:62416kB=C2=A0shadow_call_stack:15656=
kB=C2=A0pagetables:106824kB=C2=A0bounce:0kB=C2=A0free_pcp:3372kB=C2=A0local=
_pcp:176kB=C2=A0free_cma:588kB=0D=0A=5B=C2=A0=C2=A0=C2=A059.707915=5D=C2=A0=
lowmem_reserve=5B=5D:=C2=A00=C2=A00=0D=0A=5B=C2=A0=C2=A0=C2=A059.707922=5D=
=C2=A0Normal:=C2=A08*4kB=C2=A0(H)=C2=A05*8kB=C2=A0(H)=C2=A013*16kB=C2=A0(H)=
=C2=A025*32kB=C2=A0(H)=C2=A00*64kB=C2=A00*128kB=C2=A00*256kB=C2=A00*512kB=
=C2=A00*1024kB=C2=A00*2048kB=C2=A00*4096kB=C2=A0=3D=C2=A01080kB=0D=0A=5B=C2=
=A0=C2=A0=C2=A059.707942=5D=C2=A0242549=C2=A0total=C2=A0pagecache=C2=A0page=
s=0D=0A=5B=C2=A0=C2=A0=C2=A059.707951=5D=C2=A012446=C2=A0pages=C2=A0in=C2=
=A0swap=C2=A0cache=0D=0A=5B=C2=A0=C2=A0=C2=A059.707956=5D=C2=A0Swap=C2=A0ca=
che=C2=A0stats:=C2=A0add=C2=A0212408,=C2=A0delete=C2=A0199969,=C2=A0find=C2=
=A036869/71571=0D=0A=5B=C2=A0=C2=A0=C2=A059.707961=5D=C2=A0Free=C2=A0swap=
=C2=A0=C2=A0=3D=C2=A03445756kB=0D=0A=5B=C2=A0=C2=A0=C2=A059.707965=5D=C2=A0=
Total=C2=A0swap=C2=A0=3D=C2=A04194300kB=0D=0A=5B=C2=A0=C2=A0=C2=A059.707969=
=5D=C2=A0906703=C2=A0pages=C2=A0RAM=0D=0A=5B=C2=A0=C2=A0=C2=A059.707973=5D=
=C2=A00=C2=A0pages=C2=A0HighMem/MovableOnly=0D=0A=5B=C2=A0=C2=A0=C2=A059.70=
7978=5D=C2=A084528=C2=A0pages=C2=A0reserved=0D=0A=5B=C2=A0=C2=A0=C2=A059.70=
7982=5D=C2=A049152=C2=A0pages=C2=A0cma=C2=A0reserved=0D=0A=0D=0AThe=C2=A0ks=
wapd=C2=A0or=C2=A0other=C2=A0reclaim=C2=A0contexts=C2=A0may=C2=A0not=C2=A0p=
repare=C2=A0enough=C2=A0free=C2=A0pages=C2=A0for=0D=0Amany=C2=A0atomic=C2=
=A0allocations=C2=A0occurring=C2=A0in=C2=A0a=C2=A0short=C2=A0time.=C2=A0=C2=
=A0But=C2=A0zram=C2=A0may=C2=A0not=C2=A0be=0D=0Ahelpful=C2=A0for=C2=A0these=
=C2=A0atomic=C2=A0allocations=C2=A0even=C2=A0though=C2=A0zram=C2=A0is=C2=A0=
used=C2=A0to=C2=A0reclaim.=0D=0A=0D=0ATo=C2=A0get=C2=A0one=C2=A0zs=C2=A0obj=
ect=C2=A0for=C2=A0a=C2=A0specific=C2=A0size,=C2=A0zram=C2=A0may=C2=A0alloca=
te=C2=A0several=C2=A0pages.=0D=0AAnd=C2=A0this=C2=A0can=C2=A0happen=C2=A0on=
=C2=A0different=C2=A0class=C2=A0sizes=C2=A0at=C2=A0the=C2=A0same=C2=A0time.=
=C2=A0=C2=A0This=0D=0Ameans=C2=A0zram=C2=A0may=C2=A0consume=C2=A0more=C2=A0=
pages=C2=A0to=C2=A0reclaim=C2=A0only=C2=A0one=C2=A0page.=C2=A0=C2=A0This=0D=
=0Ainefficiency=C2=A0may=C2=A0cause=C2=A0consumption=C2=A0of=C2=A0all=C2=A0=
free=C2=A0pages=C2=A0below=C2=A0watermark=C2=A0min=0D=0Aby=C2=A0a=C2=A0proc=
ess=C2=A0having=C2=A0PF_MEMALLOC=C2=A0like=C2=A0kswapd.=0D=0A=0D=0AWe=C2=A0=
can=C2=A0avoid=C2=A0this=C2=A0by=C2=A0adding=C2=A0__GFP_NOMEMALLOC.=C2=A0=
=C2=A0A=C2=A0PF_MEMALLOC=C2=A0process=C2=A0won't=0D=0Ause=C2=A0ALLOC_NO_WAT=
ERMARKS.=0D=0A=0D=0ALink:=C2=A0https://lkml.kernel.org/r/20220603055747.116=
94-1-jaewon31.kim=40samsung.com=0D=0ASigned-off-by:=C2=A0Jaewon=C2=A0Kim=C2=
=A0<jaewon31.kim=40samsung.com>=0D=0ACc:=C2=A0Minchan=C2=A0Kim=C2=A0<mincha=
n=40kernel.org>=0D=0ACc:=C2=A0Nitin=C2=A0Gupta=C2=A0<ngupta=40vflare.org>=
=0D=0ACc:=C2=A0Sergey=C2=A0Senozhatsky=C2=A0<senozhatsky=40chromium.org>=0D=
=0ACc:=C2=A0Alexey=C2=A0Romanov=C2=A0<avromanov=40sberdevices.ru>=0D=0ACc:=
=C2=A0Sooyong=C2=A0Suk=C2=A0<s.suk=40samsung.com>=0D=0ACc:=C2=A0Yong-Taek=
=C2=A0Lee=C2=A0<ytk.lee=40samsung.com>=0D=0ASigned-off-by:=C2=A0Andrew=C2=
=A0Morton=C2=A0<akpm=40linux-foundation.org>=0D=0A---=0D=0A=0D=0A=C2=A0driv=
ers/block/zram/zram_drv.c=C2=A0=7C=C2=A0=C2=A0=C2=A0=C2=A01=C2=A0+=0D=0A=C2=
=A01=C2=A0file=C2=A0changed,=C2=A01=C2=A0insertion(+)=0D=0A=0D=0A---=C2=A0a=
/drivers/block/zram/zram_drv.c=7Ezram_drv-add-__gfp_nomemalloc-not-to-use-a=
lloc_no_watermarks=0D=0A+++=C2=A0a/drivers/block/zram/zram_drv.c=0D=0A=40=
=40=C2=A0-1383,6=C2=A0+1383,7=C2=A0=40=40=C2=A0static=C2=A0int=C2=A0__zram_=
bvec_write(struct=C2=A0zram=0D=0A=C2=A0=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0handle=C2=A0=3D=C2=A0zs_malloc(zram->mem_pool,=C2=
=A0comp_len,=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0__GFP_KSWAPD_RECLAIM=C2=A0=7C=0D=0A+=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__GFP_NOMEMALLOC=C2=A0=7C=
=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0__GFP_NOWARN=C2=A0=7C=0D=0A=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__GFP_HIGHMEM=C2=A0=7C=0D=0A=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__GFP_MOVABL=
E);=0D=0A_=0D=0A=0D=0APatches=C2=A0currently=C2=A0in=C2=A0-mm=C2=A0which=C2=
=A0might=C2=A0be=C2=A0from=C2=A0jaewon31.kim=40samsung.com=C2=A0are=0D=0A=
=0D=0A=0D=0A
