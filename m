Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17123C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 01:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB12064F38
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 01:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCRBFt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 21:05:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhCRBFm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 21:05:42 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12I12gC0004348;
        Wed, 17 Mar 2021 21:04:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : reply-to : to : cc : date : in-reply-to : references : content-type
 : mime-version : content-transfer-encoding; s=pp1;
 bh=WGsANUFrUE/AfQaqL+QlP8WOsIB7PLnp5G7cxYViNXk=;
 b=a+17qe+I80grIZ6IF9UT9bBe7d5Q7af+ya+jYsYHL4m8rIA2Ky3lfXL/1nFBTMHY3nGf
 4TmyTA4EmVNVH7puQVrG9Dau+0dLe/+l4JLr+8eg7H33pHBfxGq66njkAULUvc8aIcE7
 8EBwEBxJdFstaEiiu862CkHvqyFek8knlkEsvSDiB8Uut2wBmuhN7ZYh21LgEETIPXJM
 YWF5N8UlZ0x3PI7jJ8qhSDPvdqXh1F2UOJxUn+rTF9fl+7xZu4VfRH4QzyvA3e9xkhuJ
 i0lQfFsInKE+s3IwVsbC7IdgJXkaJ+abjwhIEJrMLOqvAu7pIt4khZG+lMubRf+vE6Dv Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrec95n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 21:04:45 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12I12nM5004813;
        Wed, 17 Mar 2021 21:04:44 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37bnrec954-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 21:04:44 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12I11r4U032098;
        Thu, 18 Mar 2021 01:04:43 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 378n19b13s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 01:04:43 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12I14grF31588830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 01:04:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 050337805E;
        Thu, 18 Mar 2021 01:04:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3C0D78060;
        Thu, 18 Mar 2021 01:04:36 +0000 (GMT)
Received: from jarvis.int.hansenpartnership.com (unknown [9.80.237.238])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 01:04:36 +0000 (GMT)
Message-ID: <328fc22782a1964933796017c4d7787e2b522d6e.camel@linux.ibm.com>
Subject: Re: + mm-add-definition-of-pmd_page_order.patch added to -mm tree
From:   James Bottomley <jejb@linux.ibm.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     akpm@linux-foundation.org, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, david@redhat.com,
        elena.reshetova@intel.com, guro@fb.com, hagen@jauu.net,
        hpa@zytor.com, kirill@shutemov.name, luto@kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mtk.manpages@gmail.com, palmer@dabbelt.com,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        peterz@infradead.org, rick.p.edgecombe@intel.com,
        rppt@linux.ibm.com, shakeelb@google.com, shuah@kernel.org,
        tglx@linutronix.de, tycho@tycho.ws, viro@zeniv.linux.org.uk,
        will@kernel.org
Date:   Wed, 17 Mar 2021 18:04:35 -0700
In-Reply-To: <20210318001538.GI3420@casper.infradead.org>
References: <20210317221512.A39Ft3LQk%akpm@linux-foundation.org>
         <20210317225402.GH3420@casper.infradead.org>
         <42da5805da8dad56818d2047b2e64c20ec7d030d.camel@linux.ibm.com>
         <20210318001538.GI3420@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_16:2021-03-17,2021-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=533 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180005
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 2021-03-18 at 00:15 +0000, Matthew Wilcox wrote:
> On Wed, Mar 17, 2021 at 04:19:06PM -0700, James Bottomley wrote:
> > On Wed, 2021-03-17 at 22:54 +0000, Matthew Wilcox wrote:
> > > On Wed, Mar 17, 2021 at 03:15:12PM -0700, 
> > > akpm@linux-foundation.org
> > > wrote:
> > > > Several architectures already have definition of PMD_ORDER as
> > > > the size of second level page table, so to avoid conflict with
> > > > these definitions use PMD_PAGE_ORDER name and update DAX
> > > > respectively.
> > > 
> > > I thought I NACKed this patch already?
> > 
> > I don't think anyone understands why.  DAX won't build on several
> > architectures, including parisc, because of this existing symbol
> > clash.
> > 
> > > The architectures should be updated to not use
> > > PMD_ORDER.  PMD_ORDER is clearly the right name for what is now
> > > PMD_PAGE_ORDER.  The architectures should be using
> > > PMD_ALLOC_ORDER or some such.
> 
> https://lore.kernel.org/linux-fsdevel/20201204034843.GM11935@casper.infradead.org/
> was where I said what I wanted.

Well that's nothing to do with this patch.  This patch is just trying
to extract the DAX definition up into a global header. 

Could we agree on PAGE_PMD_ORDER since the hugepage equivalent is
called HPAGE_PMD_ORDER?  That would at least make the naming consistent
and also solve the symbol clash ... then we can separately argue who
wants to go and ask all the architectures to rename their PMD_ORDER
definitions.

> > Well I had a patch renaming the dax specific one to DAX_PMD_ORDER
> > which you also didn't like.  Why don't you just propose the patch
> > you do like because this is a build failure on several
> > architectures currently.
> > 
> > I don't really care what colour the bike shed is ... I do care that
> > my builds fail.
> 
> I was expecting you to do the rename, since it's inconveniencing you.
> It doesn't cause me any trouble at all.

I fixed it by not building dax in the default parisc configs.

James


