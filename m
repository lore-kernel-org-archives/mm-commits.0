Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525FCC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 26 Oct 2022 20:32:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbiJZUcj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 Oct 2022 16:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiJZUcg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2022 16:32:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FEF3D5BF
        for <mm-commits@vger.kernel.org>; Wed, 26 Oct 2022 13:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666816355; x=1698352355;
  h=date:from:to:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=FN42P4ldFhpV3c4TZBVzQU/7wylQ+2lW1ZbbHo2TJ7k=;
  b=BjWl8PyHUfjDA4pNml4UeUW6aUaKNrtgAvSB9/pfPPURmDWRQ6qhNEfU
   dJEeHxrsOvC+OFALHzwUapPKitkkQBi6KLvUkkLqzWq+WsWljRvio/qD1
   QN2YVrkKF5M50KvBoimQLBzHN/p3nXUFp5P/b6wnF9SUuDIi8kwL+/YWQ
   I0Lb7soIVabF9A4alGdZC2GYPj7ns7EJQph/pzKTl5Rh9iR3+XqJzY+NM
   8dAEMF/6SfkwNsOTmNtjL80dFt/rkVlwaBOMdVWnLtA9lHA9icDjwugG8
   U9lYhF8CVjuT08dqacygCJjSJGxxq2yVv4WviXhLrM4qiuz/kx45xysGw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="288449294"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="288449294"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 13:32:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="701080803"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="701080803"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 26 Oct 2022 13:32:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 26 Oct 2022 13:32:33 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 26 Oct 2022 13:32:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 26 Oct 2022 13:32:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BbZV+CZZMyXoyrtUmIRuWuit0T1AfiCpMEfPbv61KjAZp1HJrZLxA5wR6X/sbgp8rI36WZvclfig66hAdFh0uwv9ppiFTuwvcJi+zbnaUJpbtNr+Z4p7OQZkgGGwopHem+ZtJiI5eYS5nYzLR0cJo+XnZCDqsXhUtjDy/9DKZxFUpjmotg0emWxxzBJhonWqxybMwFj0Xoiq8M8sColJOdpCXZjSw8YvQ6pnNEyfoY/v9UCkAEP7onQBrKJLgzbwD0Wvihbql2hLRumMnNWTTprKO6yZL1hO3GnJL/9aRUAZbiWGuKDnH6OHSWeEA/UOfqywd5Bi04gM/fFdpVKs2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpX9sCa8eaGtD18kW38Ta8gWq1KPPVqq/Sf+Uj8yY8Y=;
 b=MLOZryI7dW4Ybhbq9C7HGzUEoHbjeZOeuvNJFOPD/+B4PyEqpvs4ofV4HVZ0a2mY5Ah4N9vT3t3aX2VcQf8o/yd+dFPwSILGAgVCwfgfnAqkIjCYaD5KbGCeIZnIzsbdf05HY4zCE814HpR5DporvKSLTFmP3BB6AjD5b2IMXG9gXeMY+gcJaY+jt+/+zfyy0QuGjLDsYRg3vk8rImqtluFb3zlK15b0khftQ3XG41n+7473jM3Z/z1KDPb3KsEGGX6I139K0B8c1unOpHm84QLkpBLqB3ERS6+w+R4f5t2I/69Hoi0vLF1wfenyaveKrrd2fTU2P1pC1EUtkzyS1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20) by MW5PR11MB5785.namprd11.prod.outlook.com
 (2603:10b6:303:197::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 20:32:32 +0000
Received: from MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83]) by MWHPR1101MB2126.namprd11.prod.outlook.com
 ([fe80::7d5a:684d:99f7:4e83%12]) with mapi id 15.20.5746.023; Wed, 26 Oct
 2022 20:32:32 +0000
Date:   Wed, 26 Oct 2022 13:32:29 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Felix Kuehling <felix.kuehling@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <mm-commits@vger.kernel.org>, <Xinhui.Pan@amd.com>,
        <willy@infradead.org>, <lyude@redhat.com>, <kherbst@redhat.com>,
        <jhubbard@nvidia.com>, <jglisse@redhat.com>, <jgg@nvidia.com>,
        <jack@suse.cz>, <hch@lst.de>, <djwong@kernel.org>,
        <daniel@ffwll.ch>, <christian.koenig@amd.com>,
        <bskeggs@redhat.com>, <apopple@nvidia.com>,
        <alexander.deucher@amd.com>, <airlied@linux.ie>,
        <dan.j.williams@intel.com>, Yang Li <yang.lee@linux.alibaba.com>
Subject: Re: +
 mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch added to
 mm-unstable branch
Message-ID: <6359995d2415_4da329482@dwillia2-xfh.jf.intel.com.notmuch>
References: <20221021192639.3FDBBC433C1@smtp.kernel.org>
 <3a35bcc0-71df-c302-081d-990c5e5ed096@amd.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a35bcc0-71df-c302-081d-990c5e5ed096@amd.com>
X-ClientProxiedBy: BY3PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:a03:255::10) To MWHPR1101MB2126.namprd11.prod.outlook.com
 (2603:10b6:301:50::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2126:EE_|MW5PR11MB5785:EE_
X-MS-Office365-Filtering-Correlation-Id: d8344016-223b-46a2-6a8e-08dab7913566
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ksACU4VI9dCIq5mMBVx3OkwSCKEE6eiqNMJN3X9onqeSlKwWR7iP5Psjk3e9Dm7G7W3ozuvvdU+WHn7OUgHehunDy6RrXCEbIBN+4mcw2di8T8AQZMqfHte46tLx8H2TfJnK570MBnAGWNT0qotQ+h/v4p5h6pwWoF4Mva6kRxqatHH6V7iblPelxLYSxCLvgzxtQCxTakQ3S++8XmphcklLW0by/sxx34bsK+CRqNVfFmeBIqfm7XfU/rRfL1T/qLtfpAKwf6MMJpj6Jfe3TIsLRZsHD8VrM3tOJKbmSz8ciSugbOnPXxXIWlmjQsvrrB+a6DyTgVulctgwGxpQf1BZaovk+36NNskZ7rjw6J0p8whCoE4SaFAznzdsU2pQ3bGdd6ZzE3814gl53+kIadovLzpkUEqSCql3cyf6dGzDBe7loJrROERBlkcycebfQSy8DxAZr3SJFzxauHNN3oTmcvUU1EcwLXS6SCmLvsNLeL4cXdwZpEOZWpw23XnGyGarnu7Yqu/o8iuojq+zLZDA4joizWDh4Q5Pq5h3wSZErn1N/bw/vugzKz4Q2AoJJa87FR57BFwA0a8vtqC6eU5sBPMQXfTpshHcfxc4+tHNJxeABAb8Jk5DfNbtZcZvo+YTIf4sg6HvsYscFwWO0qVXd0DJ9f7vCcSdkcXDSIOYJEDjANvx7+6T0ofgQllAu38ErJyacEQLVaTS+XJphaoFXPShpAjDklpWSyEXU+7nLLEaUkZcjY4bLuGF44oW7Ez+JYX6A3HdaASmbbKK2T2SWgLEwKDgg0eWI+OMWAXIpdfoIz8BvEKjsMzXact
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2126.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199015)(921005)(86362001)(316002)(82960400001)(83380400001)(7416002)(186003)(66574015)(5660300002)(2906002)(8936002)(8676002)(41300700001)(4001150100001)(66946007)(66476007)(6506007)(6666004)(53546011)(966005)(26005)(6512007)(110136005)(478600001)(66556008)(38100700002)(9686003)(66899015)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/0wBHY7f1h3Zb3YatxiwDT/hCxgtMGAhS8MqdSSSG1e9bXIl6gQtByglY9?=
 =?iso-8859-1?Q?8ERVDQdh7OvQA47dGfQyCZZYfRPE7y9gSjQtof0gjzle/LFykV7dzWAGWx?=
 =?iso-8859-1?Q?ogTBTPX3d2qNg4s5+O0sWuPidkvPtjLIdTmEiclkVDC98WfPNvZ4nQ10Wo?=
 =?iso-8859-1?Q?RAE3ZwO8gceV2dym0AkyJvFE2nZlgM4Eg+P1dq7WwiP8XJ+2K2ihmD9eht?=
 =?iso-8859-1?Q?eEYoAumDr08k+OoQCHJOnr8Od5H/BqA6mQOLr35iW1tcmBWCmpKkftra+d?=
 =?iso-8859-1?Q?ZedqgMDowxt8K4I0EAHxTLMm6P28zUT7zG/yiu9Rbn6o0DH85uF/ZY3v1l?=
 =?iso-8859-1?Q?kDooTMWisUVvHQtCkQfWHLAtzQOzqGV2RpZ4V3vOQ7bFUwYN3CIA0rc9nU?=
 =?iso-8859-1?Q?pKmA1FVzseKtfQNCb1aEkivpLIkFaHqQcaJkDY6A8kxPJT2GbQk615fFFt?=
 =?iso-8859-1?Q?7qlKdbvZHK9XBlYBkhSnYUVuS/3DpJmtzjW8lqQt2ddU5dMDrxf5FWoqbe?=
 =?iso-8859-1?Q?tf8QgVWqE2eIv3VwRfCeof48QK+552K8Sq94/8+kP2BsY0XiNhkNTXZ8sA?=
 =?iso-8859-1?Q?RCvsKt573Ocwf/cguaaTeXcMTccd7WSdVSLi3tdbKm9hXdxuLV3vAxjIL/?=
 =?iso-8859-1?Q?mRrMpuG1BlDpXA/SZYH7o8DFW11YHMdI+p4g81RdWUEEnJh6C14Gvaa9nm?=
 =?iso-8859-1?Q?Q6EzgxDF7EVGP4i4Bm+WObmXFpCQjwXodPxTeNFdBN5+LZ4yg1HYMc+hXg?=
 =?iso-8859-1?Q?eHnEkkdMfCb/N3HEBx4UvEH823boy7oSitO7BQqepibJ06BOUo62LN0o2+?=
 =?iso-8859-1?Q?6LZ4J/QyFHgNdyNYC/a8tqTBlMPxfI+2xRhkVT4tKyjOvRIRokGSz3OBEN?=
 =?iso-8859-1?Q?KBrHBRPjNuzhVXNAh+xy7gOmqwUfNYup0JtfLjSuNF8xMlkZqmTPM0KDcr?=
 =?iso-8859-1?Q?iEVFgaHXnzIaqLQcxSwu9a5fPdoTKxI8fvWY+DDfBzZRZzsPRFGgBsh2za?=
 =?iso-8859-1?Q?x/83cheYVYWQQV+j6TqRPnGhDgglGOmHDpMJOudOnfbEuQSdTfDiNUpitC?=
 =?iso-8859-1?Q?at9o2uWE1SkokyZqvL423/2ZTN0jky74i91la/AJz/7AoYLRzMhE207i/m?=
 =?iso-8859-1?Q?vQFlxUGEg9KrKRon2a3PTgJFBr3FtCT+99dntBU3tYi851QtEqNX3Si79J?=
 =?iso-8859-1?Q?2EZ8S9mPbug30GKbGsgbooJXfPoMhvpUSiaqI+IS3fWHGVI6JMMJDmRjVi?=
 =?iso-8859-1?Q?OfoKGj+mHz5+qgpqy9ZROzEWhVwl/ppN2wQdmDK8dbRf8RKaQpJ4Rgth6k?=
 =?iso-8859-1?Q?TzjPnKNIf5FwWFcMQ8JJMJ+HWnXXUIv4WPF/5RrdLNg9Pla5haGbQ/4v5N?=
 =?iso-8859-1?Q?fLvjxXUTi4wgMsg/7JqNKifpE86IjtNkIGAyfCmP/bE3kOX4AbVVzBiaME?=
 =?iso-8859-1?Q?l1ExSXk2gnFY1VsZd3w7WkR7C5i/AkmnrNNPjtHL3USln8o47S2RSxlQLj?=
 =?iso-8859-1?Q?5a4vXXAilVyaujiXW/L7HQGo0fiokMRLJzN2ixnXv5JBf9KaW5Uuj8aMWw?=
 =?iso-8859-1?Q?aiK0JrdxRkdKLH+suU7jIyabyihMDgBRv//Mr0nxHLUb7Abzl4czkQwwOC?=
 =?iso-8859-1?Q?oePtDfQfYroTstFqC7pQaAwz+TEemvCuEG5BAHRIS7sQlgisXhl+TI3Q?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8344016-223b-46a2-6a8e-08dab7913566
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2126.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 20:32:32.3828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9nnRgFBkFggqr2fJn2UAn7lOgcYlE4XXN/OfBcLy9LctchdkfUJiQAEVcxDuBPr4GGIaf01QImkZ4ag9/jY24Hj1RILLkOdBtXOwoieEkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5785
X-OriginatorOrg: intel.com
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Felix Kuehling wrote:
> [+Yang.Lee <yang.lee@linux.alibaba.com>]
> 
> On 2022-10-21 15:26, Andrew Morton wrote:
> 
> > The patch titled
> >       Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
> > has been added to the -mm mm-unstable branch.  Its filename is
> >       mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch
> >
> > This patch will shortly appear at
> >       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets.patch
> >
> > This patch will later appear in the mm-unstable branch at
> >      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >     a) Consider who else should be cc'ed
> >     b) Prefer to cc a suitable mailing list as well
> >     c) Ideally: find the original patch on the mailing list and do a
> >        reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> >
> > ------------------------------------------------------
> > From: Dan Williams <dan.j.williams@intel.com>
> > Subject: mm/memremap: Introduce pgmap_request_folio() using pgmap offsets
> > Date: Thu, 20 Oct 2022 14:56:39 -0700
> >
> > A 'struct dev_pagemap' (pgmap) represents a collection of ZONE_DEVICE
> > pages. The pgmap is a reference counted object that serves a similar
> > role as a 'struct request_queue'. Live references are obtained for each
> > in flight request / page, and once a page's reference count drops to
> > zero the associated pin of the pgmap is dropped as well. While a page is
> > idle nothing should be accessing it because that is effectively a
> > use-after-free situation. Unfortunately, all current ZONE_DEVICE
> > implementations deploy a layering violation to manage requests to
> > activate pages owned by a pgmap. Specifically, they take steps like walk
> > the pfns that were previously assigned at memremap_pages() time and use
> > pfn_to_page() to recall metadata like page->pgmap, or make use of other
> > data like page->zone_device_data.
> >
> > The first step towards correcting that situation is to provide a
> > API to get access to a pgmap page that does not require the caller to
> > know the pfn, nor access any fields of an idle page. Ideally this API
> > would be able to support dynamic page creation instead of the current
> > status quo of pre-allocating and initializing pages.
> >
> > On a prompt from Jason, introduce pgmap_request_folio() that operates on
> > an offset into a pgmap. It replaces the shortlived
> > pgmap_request_folios() that was continuing the layering violation of
> > assuming pages are available to be consulted before asking the pgmap to
> > make them available.
> >
> > For now this only converts the callers to lookup the pgmap and generate
> > the pgmap offset, but it does not do the deeper cleanup of teaching
> > those call sites to generate those arguments without walking the page
> > metadata. For next steps it appears the DEVICE_PRIVATE implementations
> > could plumb the pgmap into the necessary callsites and switch to using
> > gen_pool_alloc() to track which offsets of a pgmap are allocated. For
> > DAX, dax_direct_access() could switch from returning pfns to returning
> > the associated @pgmap and @pgmap_offset. Those changes are saved for
> > follow-on work.
> >
> > Link: https://lkml.kernel.org/r/166630293549.1017198.3833687373550679565.stgit@dwillia2-xfh.jf.intel.com
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > Cc: Matthew Wilcox <willy@infradead.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: "Darrick J. Wong" <djwong@kernel.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Alex Deucher <alexander.deucher@amd.com>
> > Cc: "Christian König" <christian.koenig@amd.com>
> > Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: Ben Skeggs <bskeggs@redhat.com>
> > Cc: Karol Herbst <kherbst@redhat.com>
> > Cc: Lyude Paul <lyude@redhat.com>
> > Cc: "Jérôme Glisse" <jglisse@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [snip]
> > --- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c~mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets
> > +++ a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
> [snip]
> > @@ -325,7 +328,8 @@ svm_migrate_copy_to_vram(struct amdgpu_d
> >   
> >   		dst[i] = cursor.start + (j << PAGE_SHIFT);
> >   		migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
> > -		svm_migrate_get_vram_page(prange, migrate->dst[i]);
> > +			svm_migrate_get_vram_page(&kfddev->pgmap, prange,
> > +						  migrate->dst[i]);
> 
> Yang Lee pointed out that the indentation was broken here. I don't know 
> what to do with his patch because it doesn't apply to the branches I 
> work on. What's the best way to fix this before it goes to Linus' master 
> branch?

Send a patch relative to mm-unstable, like a typical Fixes: patch, and
Andrew will roll it in / squash it when it is time for this work to roll
from mm-unstable to mm-stable.

...and apologies for the whitespace corruption, I missed that mistake.
