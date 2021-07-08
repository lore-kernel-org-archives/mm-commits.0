Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA38C07E96
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 05:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0F2161CE0
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 05:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhGHFeX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jul 2021 01:34:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55392 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhGHFeX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2021 01:34:23 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16853hbm076306;
        Thu, 8 Jul 2021 01:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=+TR4fy56oNM/ZcUQ5CoTl09067k/KlJa7R+GZHNkifs=;
 b=lhWX+bLS+iwh5PtXkoiyKlh/8wCNXUBpOpGs8SKZ0mo3v2+u96ZV26Eu8VnpIooi6eTZ
 RVcaI+OzHe+cJ+aZvxNQ5iqK/kNsadO+btfwucGVrClc7jOLdZQxBGp2RsGuYlSU6MI8
 Y6KQyhrhadUbgHCXFvbf9P593g6UDFSgyjqAV3LphZMCqi3ZfyKG5lSBsjIzrtGwQ0YJ
 jsDeB4Dx/ZwV1D6hmH32frsNrTIKPI9nDniXAf2rI/fEOkhNKCItj8RQDMKPwLqp5IiC
 aBLqs+uS6EwcrGY34wiijGQ2EMLjSWn/4UgdxQ9lDh47kh6/OM8hEO7DQziubpi8daHQ OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n286xekh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 01:31:06 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16855IHj084283;
        Thu, 8 Jul 2021 01:31:05 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n286xej9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 01:31:05 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1685M0e6000965;
        Thu, 8 Jul 2021 05:31:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5ha10n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Jul 2021 05:31:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1685V0Ba32899566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 8 Jul 2021 05:31:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C738AE057;
        Thu,  8 Jul 2021 05:31:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10DAAAE045;
        Thu,  8 Jul 2021 05:30:57 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.167.250])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  8 Jul 2021 05:30:56 +0000 (GMT)
Date:   Thu, 8 Jul 2021 08:30:55 +0300
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Roman Gushchin <guro@fb.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Peter Anvin <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [patch 12/54] PM: hibernate: disable when there are active
 secretmem users
Message-ID: <YOaNj3srVkgGhvw3@linux.ibm.com>
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010807.hHILhs811%akpm@linux-foundation.org>
 <CAHk-=whwj1JGnGChkRyzbY4BBOvDfiv=xKbvMenoC4P2dDP5pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whwj1JGnGChkRyzbY4BBOvDfiv=xKbvMenoC4P2dDP5pw@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T1eQ2a0pysP6RxLkHXqgg-uuNdtC4Ev1
X-Proofpoint-ORIG-GUID: 5jVsg1SK2xfxbp8RvVFZ3Ga8mSljFfK3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-08_01:2021-07-06,2021-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=901 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107080025
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jul 07, 2021 at 08:15:53PM -0700, Linus Torvalds wrote:
> On Wed, Jul 7, 2021 at 6:08 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Prevent hibernation whenever there are active secret memory users.
> 
> So now anybody can not only use up all memory resources with these
> fake mlock regions, they can also force laptops to run out of battery
> and crash.

Again, this feature should be explicitly enabled on the command line, so
people that prefer hibernation to suspend-to-ram won't enable secretmem.

-- 
Sincerely yours,
Mike.
